import customtkinter as ctk
import tkinter as tk
from tkinter import ttk, filedialog, messagebox, simpledialog
import subprocess
import threading
import os
import re
import time
import shutil

ctk.set_appearance_mode("Dark")
ctk.set_default_color_theme("blue")

# --- Colors (Grey Tones) ---
BG_COL = "#0e0e0e"       # Darkest
PANEL_COL = "#1a1a1a"    # Panels
SURFACE_COL = "#2a2a2a"  # Buttons / raised surfaces
OVERLAY_COL = "#3a3a3a"  # Hover
TEXT_COL = "#d4d4d4"      # Primary text
SUBTEXT_COL = "#808080"   # Secondary text
ACCENT_COL = "#e0e0e0"    # Accent / highlights
GREEN_COL = "#b0b0b0"     # Terminal text
BLUE_COL = "#ffffff"      # Run button
RED_COL = "#999999"       # Close button hover
SASH_COL = "#333333"      # Splitter
TAB_ACTIVE = "#2a2a2a"
TAB_INACTIVE = "#1a1a1a"


class LineNumbers(tk.Canvas):
    """Side canvas to draw line numbers for a text widget."""
    def __init__(self, parent, text_widget, **kwargs):
        super().__init__(parent, **kwargs)
        self.text_widget = text_widget
        self.configure(width=35, bg=PANEL_COL, highlightthickness=0, bd=0)

    def redraw(self):
        self.delete("all")
        i = self.text_widget.index("@0,0")
        while True:
            dline = self.text_widget.dlineinfo(i)
            if dline is None: break
            y = dline[1]
            linenum = str(i).split(".")[0]
            # Right align line numbers
            self.create_text(30, y, anchor="ne", text=linenum, fill=SUBTEXT_COL, font=("Menlo", 13))
            i = self.text_widget.index("%s+1line" % i)

class EditorTab:
    """Holds state for one open file tab."""
    def __init__(self, filepath, content=""):
        self.filepath = filepath  # absolute path or None for untitled
        self.content = content
        self.name = os.path.basename(filepath) if filepath else "Untitled"


class KryptoIDE(ctk.CTk):
    def __init__(self):
        super().__init__()

        self.title("Krypto Studio")
        self.geometry("1200x850")
        self.project_dir = os.getcwd()

        # Tab state
        self.tabs = []        # list of EditorTab
        self.active_tab = -1  # index into self.tabs

        self.configure(fg_color=BG_COL)

        # --- Base Layout: Row 0 = TopBar, Row 1 = Content ---
        self.grid_rowconfigure(0, weight=0)
        self.grid_rowconfigure(1, weight=1)
        self.grid_columnconfigure(0, weight=1)

        self._build_topbar()
        self._build_content()

    # ================================================================
    #  TOP BAR
    # ================================================================
    def _build_topbar(self):
        bar = ctk.CTkFrame(self, height=50, corner_radius=0, fg_color=PANEL_COL)
        bar.grid(row=0, column=0, sticky="ew")
        bar.grid_propagate(False)

        # col0: Open  |  col1: spacer  |  col2: Logo (center)  |  col3: spacer  |  col4: Run  |  col5: Settings
        bar.grid_columnconfigure(1, weight=1)
        bar.grid_columnconfigure(3, weight=1)

        bfont = ctk.CTkFont(size=13, weight="bold")
        bkw = dict(font=bfont, width=80, height=30, fg_color=SURFACE_COL,
                   hover_color=OVERLAY_COL, text_color=TEXT_COL, corner_radius=0)

        ctk.CTkButton(bar, text="📂 Open", command=self.open_file, **bkw).grid(row=0, column=0, padx=(20, 4), pady=10)

        ctk.CTkLabel(bar, text="Krypto Studio",
                     font=ctk.CTkFont(size=18, weight="bold"),
                     text_color=ACCENT_COL).grid(row=0, column=2, pady=10)

        ctk.CTkButton(bar, text="▶ Run",   command=self.run_code,
                      font=bfont, width=90, height=30,
                      fg_color=BLUE_COL, hover_color="#cccccc",
                      text_color="#0e0e0e", corner_radius=0).grid(row=0, column=4, padx=4, pady=10)

        ctk.CTkButton(bar, text="⚙", command=self._open_settings,
                      font=ctk.CTkFont(size=16), width=36, height=30,
                      fg_color=SURFACE_COL, hover_color=OVERLAY_COL,
                      text_color=TEXT_COL, corner_radius=0).grid(row=0, column=5, padx=(4, 20), pady=10)

    # ================================================================
    #  MAIN CONTENT: Sidebar + Editor/Terminal
    # ================================================================
    def _build_content(self):
        # Horizontal PanedWindow: File Tree | Editor+Terminal
        self.h_pane = tk.PanedWindow(self, orient=tk.HORIZONTAL, sashwidth=4,
                                     bg=SASH_COL, bd=0, opaqueresize=True)
        self.h_pane.grid(row=1, column=0, sticky="nsew")

        # --- File Tree (Left) ---
        tree_wrapper = tk.Frame(self.h_pane, bg=PANEL_COL)
        self.h_pane.add(tree_wrapper, minsize=180, width=220)

        tree_header = tk.Label(tree_wrapper, text="  EXPLORER", anchor="w",
                               bg=PANEL_COL, fg=SUBTEXT_COL,
                               font=("Helvetica", 11, "bold"))
        tree_header.pack(side="top", fill="x", padx=0, pady=(10, 4))

        # Style the Treeview
        style = ttk.Style(self)
        style.theme_use("clam")
        style.configure("Filetree.Treeview",
                        background=PANEL_COL, foreground=TEXT_COL,
                        fieldbackground=PANEL_COL, borderwidth=0,
                        font=("Menlo", 12), rowheight=24)
        style.configure("Filetree.Treeview.Heading", background=PANEL_COL,
                        foreground=SUBTEXT_COL, borderwidth=0)
        style.map("Filetree.Treeview",
                  background=[("selected", SURFACE_COL)],
                  foreground=[("selected", ACCENT_COL)])
        style.layout("Filetree.Treeview", [('Filetree.Treeview.treearea', {'sticky': 'nswe'})])

        self.file_tree = ttk.Treeview(tree_wrapper, style="Filetree.Treeview", show="tree")
        self.file_tree.pack(side="top", fill="both", expand=True, padx=6, pady=(0, 10))
        self.file_tree.bind("<<TreeviewOpen>>", self._on_tree_expand)
        self.file_tree.bind("<Double-1>", self._on_tree_double_click)
        self.file_tree.bind("<Button-2>", self._on_tree_right_click)  # macOS right-click
        self.file_tree.bind("<Control-Button-1>", self._on_tree_right_click)  # Ctrl+click

        self._populate_tree(self.project_dir)

        # Context menu for file tree
        self.tree_menu = tk.Menu(self, tearoff=0, bg=SURFACE_COL, fg=TEXT_COL,
                                 activebackground=OVERLAY_COL, activeforeground=TEXT_COL,
                                 font=("Helvetica", 12))
        self.tree_menu.add_command(label="📄 New File", command=self._tree_new_file)
        self.tree_menu.add_command(label="📁 New Folder", command=self._tree_new_folder)
        self.tree_menu.add_separator()
        self.tree_menu.add_command(label="🗑 Delete", command=self._tree_delete)

        # Refresh button
        refresh_btn = tk.Button(tree_wrapper, text="↻ Refresh", bg=SURFACE_COL, fg=TEXT_COL,
                                activebackground=OVERLAY_COL, activeforeground=TEXT_COL,
                                relief="flat", font=("Helvetica", 11), cursor="hand2",
                                command=self._refresh_tree)
        refresh_btn.pack(side="bottom", fill="x", padx=6, pady=(0, 10))

        # --- Right Panel: Vertical PanedWindow (Editor / Terminal) ---
        self.v_pane = tk.PanedWindow(self.h_pane, orient=tk.VERTICAL, sashwidth=5,
                                     bg=SASH_COL, bd=0, opaqueresize=True)
        self.h_pane.add(self.v_pane, minsize=400)

        # Editor Pane
        editor_wrapper = tk.Frame(self.v_pane, bg=BG_COL)
        self.v_pane.add(editor_wrapper, minsize=150, height=550)

        self.editor_frame = ctk.CTkFrame(editor_wrapper, corner_radius=0,
                                         fg_color=PANEL_COL, border_width=1, border_color=SURFACE_COL)
        self.editor_frame.pack(fill="both", expand=True, padx=(10, 16), pady=(16, 6))
        self.editor_frame.grid_rowconfigure(1, weight=1)
        self.editor_frame.grid_columnconfigure(1, weight=1)

        # Tab bar (scrollable frame of tab buttons)
        self.tab_bar = tk.Frame(self.editor_frame, bg=PANEL_COL, height=30)
        self.tab_bar.grid(row=0, column=0, columnspan=2, padx=5, pady=(5, 0), sticky="ew")

        self.editor = ctk.CTkTextbox(self.editor_frame,
                                     font=ctk.CTkFont(family="Menlo", size=15),
                                     undo=True, fg_color="transparent", text_color=TEXT_COL)
        self.editor.grid(row=1, column=1, padx=(0, 10), pady=(5, 10), sticky="nsew")

        # Line numbers canvas
        self.line_nums = LineNumbers(self.editor_frame, self.editor._textbox)
        self.line_nums.grid(row=1, column=0, padx=(5, 0), pady=(5, 10), sticky="ns")

        self.setup_syntax_highlighting()
        self.editor.bind("<KeyRelease>", self.on_key_release)
        self.editor.bind("<Button-1>", lambda e: self.line_nums.redraw())
        self.editor.bind("<MouseWheel>", lambda e: self.line_nums.after(1, self.line_nums.redraw))
        self.editor._textbox.bind("<Configure>", lambda e: self.line_nums.redraw())
        # Hook into the scrollbar of CTkTextbox if possible, or just use periodic update
        self._update_line_numbers_loop()

        # Console Pane
        console_wrapper = tk.Frame(self.v_pane, bg=BG_COL)
        self.v_pane.add(console_wrapper, minsize=100, height=200)

        self.console_frame = ctk.CTkFrame(console_wrapper, corner_radius=0,
                                          fg_color=PANEL_COL, border_width=1, border_color=SURFACE_COL)
        self.console_frame.pack(fill="both", expand=True, padx=(10, 16), pady=(6, 16))
        self.console_frame.grid_rowconfigure(1, weight=1)
        self.console_frame.grid_columnconfigure(0, weight=1)

        ctk.CTkLabel(self.console_frame, text="Terminal Output",
                     font=ctk.CTkFont(size=12, weight="bold"),
                     text_color=SUBTEXT_COL).grid(row=0, column=0, padx=15, pady=(8, 0), sticky="nw")

        self.console = ctk.CTkTextbox(self.console_frame,
                                      font=ctk.CTkFont(family="Menlo", size=13),
                                      state="disabled", fg_color="transparent", text_color=GREEN_COL)
        self.console.grid(row=1, column=0, padx=10, pady=(5, 10), sticky="nsew")

    # ================================================================
    #  TAB MANAGEMENT
    # ================================================================
    def _save_active_tab_content(self):
        """Save current editor content back into the active tab's state."""
        if 0 <= self.active_tab < len(self.tabs):
            self.tabs[self.active_tab].content = self.editor.get("1.0", "end-1c")

    def _switch_to_tab(self, index):
        """Switch editor to show the given tab."""
        if index < 0 or index >= len(self.tabs):
            return
        # Save current content
        self._save_active_tab_content()
        # Switch
        self.active_tab = index
        tab = self.tabs[index]
        self.editor.delete("1.0", "end")
        self.editor.insert("1.0", tab.content)
        self.title(f"Krypto Studio - {tab.name}")
        self.on_key_release()
        self._render_tab_bar()

    def _close_tab(self, index):
        """Close a tab by index."""
        if index < 0 or index >= len(self.tabs):
            return
        # Save content of current tab before we do anything
        self._save_active_tab_content()

        # Auto-save the closing tab's content to disk
        closing_tab = self.tabs[index]
        if closing_tab.filepath:
            try:
                with open(closing_tab.filepath, "w") as f:
                    f.write(closing_tab.content)
            except Exception:
                pass

        self.tabs.pop(index)
        if len(self.tabs) == 0:
            self.active_tab = -1
            self.editor.delete("1.0", "end")
            self.title("Krypto Studio")
            self._render_tab_bar()
            return

        # Adjust active index
        if self.active_tab >= len(self.tabs):
            self.active_tab = len(self.tabs) - 1
        elif self.active_tab > index:
            self.active_tab -= 1
        elif self.active_tab == index:
            self.active_tab = min(index, len(self.tabs) - 1)

        tab = self.tabs[self.active_tab]
        self.editor.delete("1.0", "end")
        self.editor.insert("1.0", tab.content)
        self.title(f"Krypto Studio - {tab.name}")
        self.on_key_release()
        self._render_tab_bar()

    def _render_tab_bar(self):
        """Rebuild the tab bar buttons."""
        for w in self.tab_bar.winfo_children():
            w.destroy()

        for i, tab in enumerate(self.tabs):
            is_active = (i == self.active_tab)
            bg = TAB_ACTIVE if is_active else TAB_INACTIVE
            fg = ACCENT_COL if is_active else SUBTEXT_COL

            frame = tk.Frame(self.tab_bar, bg=bg)
            frame.pack(side="left", padx=(0, 2))

            idx = i  # capture

            label = tk.Label(frame, text=f" {tab.name} ", bg=bg, fg=fg,
                             font=("Menlo", 11), cursor="hand2")
            label.pack(side="left", padx=(6, 0), pady=2)
            label.bind("<Button-1>", lambda e, idx=idx: self._switch_to_tab(idx))

            close_btn = tk.Label(frame, text="✕", bg=bg, fg="#6c7086",
                                 font=("Helvetica", 10), cursor="hand2")
            close_btn.pack(side="left", padx=(2, 4), pady=2)
            close_btn.bind("<Button-1>", lambda e, idx=idx: self._close_tab(idx))
            close_btn.bind("<Enter>", lambda e, w=close_btn: w.configure(fg="#ffffff"))
            close_btn.bind("<Leave>", lambda e, w=close_btn: w.configure(fg="#555555"))

    def _open_in_tab(self, filepath, content=""):
        """Open a file in a new tab or switch if already open."""
        # Check if already open
        for i, tab in enumerate(self.tabs):
            if tab.filepath and tab.filepath == filepath:
                self._switch_to_tab(i)
                return

        self._save_active_tab_content()
        new_tab = EditorTab(filepath, content)
        self.tabs.append(new_tab)
        self._switch_to_tab(len(self.tabs) - 1)

    # ================================================================
    #  FILE TREE
    # ================================================================
    IGNORED = {".git", "__pycache__", "build", ".DS_Store", "node_modules", "egitim"}

    def _populate_tree(self, root_path):
        self.file_tree.delete(*self.file_tree.get_children())
        root_name = os.path.basename(root_path) or root_path
        root_node = self.file_tree.insert("", "end", text=f"📁 {root_name}", values=(root_path,), open=True)
        self._fill_tree_node(root_node, root_path)

    def _fill_tree_node(self, parent, path):
        try:
            entries = sorted(os.listdir(path))
        except PermissionError:
            return
        dirs, files = [], []
        for e in entries:
            if e in self.IGNORED or e.startswith("."):
                continue
            full = os.path.join(path, e)
            if os.path.isdir(full):
                dirs.append(e)
            else:
                files.append(e)

        for d in dirs:
            full = os.path.join(path, d)
            node = self.file_tree.insert(parent, "end", text=f"📁 {d}", values=(full,))
            # Insert a dummy child so the expand arrow shows
            self.file_tree.insert(node, "end", text="")

        for f in files:
            full = os.path.join(path, f)
            icon = "📄"
            if f.endswith(".kp"):
                icon = "💎"
            elif f.endswith(".scm"):
                icon = "🔧"
            elif f.endswith(".py"):
                icon = "🐍"
            elif f.endswith(".md"):
                icon = "📝"
            elif f.endswith(".j"):
                icon = "☕"
            self.file_tree.insert(parent, "end", text=f"{icon} {f}", values=(full,))

    def _on_tree_expand(self, event):
        node = self.file_tree.focus()
        children = self.file_tree.get_children(node)
        # If there's a single dummy child, populate for real
        if len(children) == 1 and self.file_tree.item(children[0], "text") == "":
            self.file_tree.delete(children[0])
            path = self.file_tree.item(node, "values")[0]
            self._fill_tree_node(node, path)

    def _on_tree_double_click(self, event):
        node = self.file_tree.focus()
        if not node:
            return
        values = self.file_tree.item(node, "values")
        if not values:
            return
        path = values[0]
        if os.path.isfile(path):
            self._open_file_from_path(path)

    def _on_tree_right_click(self, event):
        """Show context menu on right-click."""
        # Select the item under cursor
        item = self.file_tree.identify_row(event.y)
        if item:
            self.file_tree.selection_set(item)
            self.file_tree.focus(item)
        self.tree_menu.post(event.x_root, event.y_root)

    def _get_tree_selected_dir(self):
        """Get the directory path for the selected tree item."""
        node = self.file_tree.focus()
        if not node:
            return self.project_dir
        values = self.file_tree.item(node, "values")
        if not values:
            return self.project_dir
        path = values[0]
        if os.path.isdir(path):
            return path
        return os.path.dirname(path)

    def _tree_new_file(self):
        """Create a new file in the selected directory."""
        target_dir = self._get_tree_selected_dir()
        name = simpledialog.askstring("New File", "File name:",
                                      parent=self)
        if not name:
            return
        filepath = os.path.join(target_dir, name)
        if os.path.exists(filepath):
            messagebox.showerror("Error", f"'{name}' already exists.")
            return
        try:
            with open(filepath, "w") as f:
                f.write("")
        except Exception as e:
            messagebox.showerror("Error", str(e))
            return
        self._refresh_tree()
        self._open_file_from_path(filepath)

    def _tree_new_folder(self):
        """Create a new folder in the selected directory."""
        target_dir = self._get_tree_selected_dir()
        name = simpledialog.askstring("New Folder", "Folder name:",
                                      parent=self)
        if not name:
            return
        dirpath = os.path.join(target_dir, name)
        try:
            os.makedirs(dirpath, exist_ok=True)
        except Exception as e:
            messagebox.showerror("Error", str(e))
            return
        self._refresh_tree()

    def _tree_delete(self):
        """Delete the selected file or folder."""
        node = self.file_tree.focus()
        if not node:
            return
        values = self.file_tree.item(node, "values")
        if not values:
            return
        path = values[0]
        name = os.path.basename(path)
        if not messagebox.askyesno("Delete", f"Delete '{name}'?"):
            return
        try:
            if os.path.isdir(path):
                shutil.rmtree(path)
            else:
                os.remove(path)
                # Close tab if open
                for i, tab in enumerate(self.tabs):
                    if tab.filepath == path:
                        self._close_tab(i)
                        break
        except Exception as e:
            messagebox.showerror("Error", str(e))
            return
        self._refresh_tree()

    def _refresh_tree(self):
        self._populate_tree(self.project_dir)

    def _open_file_from_path(self, filepath):
        try:
            with open(filepath, "r") as f:
                content = f.read()
        except Exception:
            return
        self._open_in_tab(filepath, content)

    # ================================================================
    #  SYNTAX HIGHLIGHTING
    # ================================================================
    def setup_syntax_highlighting(self):
        txt = self.editor._textbox
        # One Dark inspired palette
        txt.tag_configure("Keyword", foreground="#C678DD", font=ctk.CTkFont(family="Menlo", size=15, weight="bold"))
        txt.tag_configure("Type", foreground="#E5C07B")
        txt.tag_configure("String", foreground="#98C379")
        txt.tag_configure("Number", foreground="#D19A66")
        txt.tag_configure("Comment", foreground="#5C6370", font=ctk.CTkFont(family="Menlo", size=15, slant="italic"))
        txt.tag_configure("Boolean", foreground="#D19A66")
        txt.tag_configure("Function", foreground="#61AFEF", font=ctk.CTkFont(family="Menlo", size=15, weight="bold"))
        txt.tag_configure("Operator", foreground="#56B6C2")

        self.keywords = ["fun", "if", "else", "while", "for", "return", "let", "print", "struct", "null"]
        self.types = ["int", "float", "bool", "string", "void"]
        self.booleans = ["true", "false"]

    def on_key_release(self, event=None):
        txt = self.editor._textbox
        for tag in ["Keyword", "Type", "String", "Number", "Comment", "Boolean", "Function", "Operator"]:
            txt.tag_remove(tag, "1.0", "end")

        content = self.editor.get("1.0", "end-1c")
        if not content:
            return

        # Keywords
        for kw in self.keywords:
            for m in re.finditer(r'\b' + kw + r'\b', content):
                txt.tag_add("Keyword", f"1.0+{m.start()}c", f"1.0+{m.end()}c")
        
        # Types
        for ty in self.types:
            for m in re.finditer(r'\b' + ty + r'\b', content):
                txt.tag_add("Type", f"1.0+{m.start()}c", f"1.0+{m.end()}c")
        
        # Booleans
        for b in self.booleans:
            for m in re.finditer(r'\b' + b + r'\b', content):
                txt.tag_add("Boolean", f"1.0+{m.start()}c", f"1.0+{m.end()}c")

        # Function definitions
        for m in re.finditer(r'\bfun\s+([a-zA-Z_][a-zA-Z0-9_]*)', content):
            start = m.start(1)
            end = m.end(1)
            txt.tag_add("Function", f"1.0+{start}c", f"1.0+{end}c")

        # Operators
        for m in re.finditer(r'[+\-*/%=<>!&|]', content):
            txt.tag_add("Operator", f"1.0+{m.start()}c", f"1.0+{m.end()}c")

        for m in re.finditer(r'"[^"]*"', content):
            txt.tag_add("String", f"1.0+{m.start()}c", f"1.0+{m.end()}c")
        for m in re.finditer(r'\b\d+(\.\d+)?\b', content):
            txt.tag_add("Number", f"1.0+{m.start()}c", f"1.0+{m.end()}c")
        for m in re.finditer(r'//.*', content):
            txt.tag_add("Comment", f"1.0+{m.start()}c", f"1.0+{m.end()}c")
        
        # Redraw line numbers
        self.line_nums.redraw()

    def _update_line_numbers_loop(self):
        """Periodically refresh line numbers to ensure sync with scrolling."""
        if hasattr(self, "line_nums"):
            self.line_nums.redraw()
        self.after(200, self._update_line_numbers_loop)

    # ================================================================
    #  SETTINGS
    # ================================================================
    def _open_settings(self):
        win = ctk.CTkToplevel(self)
        win.title("Settings")
        win.geometry("320x200")
        win.configure(fg_color=PANEL_COL)
        win.transient(self)
        win.grab_set()

        ctk.CTkLabel(win, text="Settings", font=ctk.CTkFont(size=16, weight="bold"),
                     text_color=ACCENT_COL).pack(pady=(15, 10))

        # Font size
        size_frame = ctk.CTkFrame(win, fg_color="transparent")
        size_frame.pack(fill="x", padx=20, pady=5)
        ctk.CTkLabel(size_frame, text="Font Size", text_color=TEXT_COL).pack(side="left")
        size_var = tk.IntVar(value=15)
        def _apply_size(val):
            sz = int(float(val))
            self.editor.configure(font=ctk.CTkFont(family="Menlo", size=sz))
        size_slider = ctk.CTkSlider(size_frame, from_=10, to=24, number_of_steps=14,
                                     variable=size_var, command=_apply_size,
                                     fg_color=SURFACE_COL, progress_color=ACCENT_COL,
                                     button_color=ACCENT_COL, button_hover_color=TEXT_COL)
        size_slider.pack(side="right", fill="x", expand=True, padx=(10, 0))

        # About
        ctk.CTkLabel(win, text="Krypto Studio v0.5.0\nKrypto Language IDE",
                     text_color=SUBTEXT_COL, font=ctk.CTkFont(size=11)).pack(pady=(15, 5))

        ctk.CTkButton(win, text="Close", command=win.destroy,
                      fg_color=SURFACE_COL, hover_color=OVERLAY_COL,
                      text_color=TEXT_COL, corner_radius=0, width=80).pack(pady=10)

    # ================================================================
    #  FILE OPS
    # ================================================================
    def log_console(self, text, clear=False):
        self.console.configure(state="normal")
        if clear:
            self.console.delete("1.0", "end")
        self.console.insert("end", text + "\n")
        self.console.see("end")
        self.console.configure(state="disabled")

    def new_file(self):
        """Open a new untitled tab."""
        self._save_active_tab_content()
        new_tab = EditorTab(None, "")
        self.tabs.append(new_tab)
        self._switch_to_tab(len(self.tabs) - 1)

    def open_file(self):
        filepath = filedialog.askopenfilename(
            defaultextension=".kp",
            filetypes=[("Krypto Files", "*.kp"), ("All Files", "*.*")])
        if filepath:
            self._open_file_from_path(filepath)

    def _save_current_file(self):
        """Save the active tab's content to disk."""
        if self.active_tab < 0:
            return
        self._save_active_tab_content()
        tab = self.tabs[self.active_tab]
        if not tab.filepath:
            # Untitled — ask for save location
            tab.filepath = filedialog.asksaveasfilename(
                defaultextension=".kp",
                filetypes=[("Krypto Files", "*.kp"), ("All Files", "*.*")])
            if not tab.filepath:
                return
            tab.name = os.path.basename(tab.filepath)
            self._render_tab_bar()
        with open(tab.filepath, "w") as f:
            f.write(tab.content)
        self.title(f"Krypto Studio - {tab.name}")

    def extract_file_for_compilation(self) -> str:
        if self.active_tab < 0:
            return os.path.join(self.project_dir, "temp.kp")
        self._save_active_tab_content()
        tab = self.tabs[self.active_tab]
        if not tab.filepath:
            target_file = os.path.join(self.project_dir, "temp.kp")
            with open(target_file, "w") as f:
                f.write(tab.content)
            return target_file
        else:
            # Auto-save before build
            with open(tab.filepath, "w") as f:
                f.write(tab.content)
            return tab.filepath

    # ================================================================
    #  BUILD PIPELINE
    # ================================================================
    def run_command_in_console(self, cmd, description):
        self.log_console(f"--- {description} ---")
        try:
            process = subprocess.Popen(
                cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, shell=True)
            for line in iter(process.stdout.readline, ''):
                self.log_console(line.rstrip('\n'))
            process.stdout.close()
            process.wait()
            return process.returncode
        except Exception as e:
            self.log_console(f"Execution Error: {str(e)}")
            return 1

    def pipeline_worker(self):
        target_file = self.extract_file_for_compilation()
        self.log_console("Starting Application Pipeline...", clear=True)
        self.log_console(f"Target: {target_file}\n")

        time.sleep(0.1)

        build_dir = os.path.join(self.project_dir, "build")
        os.makedirs(build_dir, exist_ok=True)

        cmd_compile = f"chez --script src/main.scm build {target_file}"
        code = self.run_command_in_console(cmd_compile, "Step 1/3: Compiling to Jasmin Assembly (chez)")
        if code != 0:
            self.log_console("\n[!] Build FAILED. Check compiler logs.")
            return

        src_j = os.path.join(self.project_dir, "Main.j")
        dst_j = os.path.join(build_dir, "Main.j")
        if os.path.exists(src_j):
            shutil.move(src_j, dst_j)

        jasmin_path = os.path.join(self.project_dir, "toolchain", "jasmin.jar")
        cmd_assemble = f"java -jar {jasmin_path} -d {build_dir} {dst_j}"
        code = self.run_command_in_console(cmd_assemble, "Step 2/3: Assembling to JVM Bytecode (jasmin)")
        if code != 0:
            self.log_console("\n[!] Assemble FAILED. Invalid Jasmin generated.")
            return

        cmd_run = f"java -cp {build_dir} Main"
        code = self.run_command_in_console(cmd_run, "Step 3/3: Executing on JVM (java Main)")

        if code == 0:
            self.log_console("\n>>> Program exited with code 0 (Success) <<<")
        else:
            self.log_console(f"\n>>> Program exited with error code {code} <<<")

    def run_code(self):
        thread = threading.Thread(target=self.pipeline_worker)
        thread.start()


if __name__ == "__main__":
    app = KryptoIDE()
    app.mainloop()
