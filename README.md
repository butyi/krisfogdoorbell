# Krisfog Doorbell

## Introduction

[Team leave gift](https://github.com/butyi/tlg) sound player was ordered by Krisfog for his doorbell for fun.

![board top](https://github.com/butyi/krisfogdoorbell/blob/main/img1.jpg)

![board buttom](https://github.com/butyi/krisfogdoorbell/blob/main/img2.jpg)

## Hardware

The hardware is [sci2can board](https://github.com/butyi/sci2can) V1.0
Dispay is not needed in this project.

### Supply

DC supply is not used. 5V to be conntected to power connector of board. Simple old (low current) USB charger is sufficient. 

### Button

`In` is button input. `Out` is shorted to ground on the PCB.
Button input is on PTE1 pin. Pin is pulled up by software.
Button connected between `In` and `Out` shorts PTE1 pin to ground.
This means falling edge of PTE1 pin is button push event.

### Speaker

Two speaker phrases are connected to CAN connectors. CAN is not used, tranceiver is not populated.

## Software

Software is simple pure assembly code.

### Function

Button push event pulls up wave counter to 3. Wave playing is started.
After wave is layed 3 times, play stops, software waits for next push event.
Status LED shows the active wave playing.

### Compile

- Download assembler from [aspisys.com](http://www.aspisys.com/asm8.htm).
  It works on both Linux and Windows.
- Check out the repo
- Run my bash file `./c`.
  Or run `asm8 prg.asm` on Linux, `asm8.exe prg.asm` on Windows.
- prg.s19 is now ready to download.

### Download

I have used the cheap USBDM Hardware interface. I have bought it for 10€ on Ebay.
Just search "USBDM S08".

USBDM has free software tool support for S08 microcontrollers.
You can download it from [here](https://sourceforge.net/projects/usbdm/).
When you install the package, you will have Flash Downloader tools for several
target controllers. Once is for S08 family.

It is much more comfortable and faster to call the download from command line.
Just run my bash file `./p`.

## License

This is free. You can do anything you want with it.
While I am using Linux, I got so many support from free projects,
I am happy if I can give something back to the community.

## Keywords

PWM, PulseWidthModulation, Waveform, Audio, Player, Door, Bell, Speaker
Motorola, Freescale, NXP, MC68HC9S08DZ60, 68HC9S08DZ60, HC9S08DZ60, MC9S08DZ60,
9S08DZ60, HC9S08DZ48, HC9S08DZ32, HC9S08DZ, 9S08DZ, UART, RS232.

###### 2022 Janos BENCSIK


