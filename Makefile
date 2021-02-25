x86_asm_src_files := $(shell find src/arch/x86 -name *.asm)
x86_asm_obj_files := $(patsubst src/arch/x86/%.asm, build/arch/x86/%.o, $(x86_asm_src_files))

$(x86_asm_obj_files): build/arch/x86/%.o : src/arch/x86/%.asm
	mkdir -p $(dir $@) && \
	nasm -f elf64 $(patsubst build/arch/x86/%.o, src/arch/x86/%.asm, $@) -o $@


.PHONY: build-x86
build-x86: $(x86_asm_obj_files)
	mkdir -p dist/x86 && .
	x86_64-elf-ld -n -o dist/x86/kernel.bin -T targets/x86/linker.ld $(x86_asm_obj_files) && \
	cp dist/x86/kernel.bin targets/x86/iso/boot/kernel.bin && \
	grub-mkrescue /usr/lib/grub/i386-pc -o dist/x86/kernel.iso targets/x86/iso
