# Krisfog Doorbell

## Introduction

[Team leave gift](https://github.com/butyi/tlg) sound player was ordered by Krisfog for his doorbell for fun.

![board top](https://github.com/butyi/krisfogdoorbell/blob/main/img1.jpg)

![board buttom](https://github.com/butyi/krisfogdoorbell/blob/main/img2.jpg)

## Hardware

The hardware is [sci2can board V1.0](https://github.com/butyi/sci2can/blob/1777978958673a1c9e5d99a9fa1fe0c1f72ebfce/hw/sci2can_sch.pdf)

### Supply

DC-DC step-down supply is not populated. 
3V ... 5V to be conntected to power connector of board.
Since uC goes to low power mode after a wave play, battery supply is the best choice.
Best battery is some 3.6V type. Like 18650 or a not used mobile phone battery.
In sleep, circuit needs 5 uA only. This is very low current.
With a 2500mAh 18650 battery, standby lifetime is 2.5Ah / 0.000005 A = half million hours = 20833 days = 57 years.
If you do not like battery, a simple USB charger is also sufficient.

### Button

`In` is button input. `Out` is shorted to ground on the PCB.
Button input is on PTA7 IRQ pin. Pin is pulled up by external 10kOhm resistor.
Button connected between `In` and `Out` shorts IRQ pin to ground.
This means falling edge of IRQ pin is wake up button push event.

### Speaker

Two speaker phrases are connected to CAN connectors. CAN is not used, tranceiver is not populated.

## Software

Software is simple pure assembly code.

### Function

Button push event wakes up the uC, pulls up wave counter to 3, starts to play the wave.
After wave is layed 3 times, play goes to low power mode (Stop3 mode) and waits for next push event (IRQ wake up interrupt).
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


