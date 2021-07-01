(module nvim-config
  {autoload {nvim aniseed.nvim
             core aniseed.core
             compe compe
             ts nvim-treesitter.configs}})

; In ~/.local/share/nvim/site/pack/plugins/start, clone
; Olical/aniseed, jeffkreeftmeijer/vim-dim, hrsh7th/nvim-compe,
; nvim-treesitter/nvim-treesitter

(ts.setup {:ensure_installed [:c :scala]
           :highlight {:enable true}
           :indent {:enable true}})

(nvim.ex.colorscheme :dim)

(core.assoc
  nvim.o
  :background :dark
  :mouse :a
  :shell :fish

  :tabstop 4
  :softtabstop 4
  :shiftwidth 4

  :foldmethod :indent
  :foldlevel 99
  :foldtext ""
  :foldignore ""

  :clipboard :unnamedplus
  :completeopt "menuone,noselect")

(core.run!
  nvim.ex.set
  [:title
   :expandtab
   :nofixeol
   :undofile
   :ruler
   :confirm
   :hidden])

(compe.setup 
  {:enabled true
   :autocomplete true
   :debug false
   :min_length 1
   :preselect "enable"
   :throttle_time 80
   :source_timeout 200
   :incomplete_delay 400
   :max_abbr_width 100
   :max_kind_width 100
   :max_menu_width 100
   :documentation true

   :source {:path true
            :buffer true
            :calc true
            :nvim_lsp true
            :nvim_lua true
            :vsnip true
            :ultisnips true
            }})


; translate (map mode lhs rhs opt1 opt2) to
; (nvim.set_keymap mode lhs rhs {opt1 true opt2 true})
(defn- map [mode lhs rhs ...]
  (let [opts {}]
    (for [i 1 (select :# ...)]
      (tset opts (select i ...) true))
    (nvim.set_keymap mode lhs rhs opts)))

(map :i :jk :<Esc> :noremap)
(map :t :jk :<C-\><C-n> :noremap)
(map :c :jk :<C-c> :noremap)

; ctrl-h ctrl-l to move cursor across windows
; ctrl-j ctrl-k to rotate between buffers in current window

(defn- navkeys [mode esc-code]
  (let [esc #(.. esc-code $1)]
    (map mode :<C-H> (esc :<C-w>W) :noremap :silent)
    (map mode :<C-J> (esc ::bprev<CR>) :noremap :silent)
    (map mode :<C-K> (esc ::bnext<CR>) :noremap :silent)
    (map mode :<C-L> (esc :<C-w>w) :noremap :silent)))

(navkeys :t :<C-\><C-n>)
(navkeys :n "")
(navkeys :i :<C-o>)
