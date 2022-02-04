define init-peda
source /dbg/peda-src/peda.py
end
document init-peda
Initializes the PEDA (Python Exploit Development Assistant for GDB) framework
end

define init-pwndbg
source /dbg/pwndbg-src/gdbinit.py
end
document init-pwndbg
Initializes PwnDBG
end

define init-gef
source /dbg/.gdbinit-gef.py
end
document init-gef
Initializes GEF (GDB Enhanced Features)
end
