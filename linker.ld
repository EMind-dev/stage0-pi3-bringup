ENTRY(_start)
SECTIONS {
  . = 0x80000;

  .text : {
    *(.text*)
  }

  .rodata : {
    *(.rodata*)
  }

  .bss : {
    _bss_start = .;
    *(.bss*)
    _bss_end = .;
  }

  . = ALIGN(16);
  _stack_top = . + 0x1000;
}