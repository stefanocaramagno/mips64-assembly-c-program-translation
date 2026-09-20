# C Program Translation into MIPS64 Assembly

C Program Translation into MIPS64 Assembly is a collection of ten standalone exercises that translate structured C programs into MIPS64 assembly. The project demonstrates how iteration, branching, procedures, string processing, numeric input, and result reporting can be expressed through low-level instructions while preserving the intent and control flow of the original programs. Each exercise places the reference C program beside its assembly translation, making the repository suitable for studying the relationship between the two representations and for observing program execution in a processor simulator.

## Overview

The exercises are independent and can be opened in any order. Every exercise contains the original C implementation as comments, followed by its MIPS64 translation. Together, they cover:

- counted and condition-controlled loops;
- conditional branches and early returns;
- procedure calls, arguments, return values, and stack management;
- character-by-character string processing;
- decimal input conversion and formatted output;
- arithmetic operations, comparisons, division, and remainders.

The repository includes ILPSim 1.8, a graphical instruction-set simulator capable of running MIPS64 sources and exposing processor state during execution. A shared assembly module provides unsigned decimal input for the exercises that require an integer value.

## Exercise Guide

| Source | Main focus |
| --- | --- |
| `exercise_01.s` | Procedure-based accumulation of the digits in an input string |
| `exercise_02.s` | Bounded string inspection with an early-return condition |
| `exercise_03.s` | Conditional processing of a user-selected string prefix |
| `exercise_04.s` | Alternative execution paths based on the input length |
| `exercise_05.s` | Minimum-length validation with a `do-while` style loop and conditional scoring |
| `exercise_06.s` | Counting even digits and comparing the result with a user estimate |
| `exercise_07.s` | A compound loop-termination condition and digit comparisons |
| `exercise_08.s` | Filtered digit accumulation with a sentinel return value |
| `exercise_09.s` | Optional early termination and remainder-based accumulation |
| `exercise_10.s` | Filtered numeric processing with conditional result reporting |

The `input_unsigned.s` file is a support module included by the relevant exercises. It converts a sequence of decimal characters entered through the simulator into an unsigned integer. It is not a standalone exercise.

## Requirements

To run the complete project on Windows, macOS, or Linux, the system must provide:

- a graphical desktop environment;
- a Java Runtime Environment version 8 or later;
- a terminal with the `java` executable available on the system `PATH`.

The simulator is already included as `ILPSim1.8.jar`, so no project build step or additional dependency download is required.

Verify the Java installation from a terminal:

```text
java -version
```

If the command is not recognized, install a Java Runtime Environment and reopen the terminal before continuing.

## Running the Exercises

The following workflow is the same on Windows, macOS, and Linux.

1. Open a terminal and change to the repository directory:

   ```text
   cd <repository-directory>
   ```

2. Start the bundled simulator:

   ```text
   java -jar ILPSim1.8.jar
   ```

3. In ILPSim, select `File > Open` and choose one of the files from `exercise_01.s` through `exercise_10.s`.

4. Use `Execute > Run` to execute the program until it reaches its termination system call. When prompted, enter the requested strings or unsigned integers in the simulator's Input/Output window. Follow the length and character constraints shown by each program.

5. Inspect the Input/Output, Registers, Instruction Status, and Statistics windows as needed. For cycle-level analysis, use `Execute > Single cycle` or `Execute > Multiple cycles` instead of `Run`.

6. Select `Execute > Reset` before running the same source again. To continue with the complete collection, open the next exercise and repeat steps 4 and 5 until all ten sources have been executed.

Keep `input_unsigned.s` in the same directory as the exercise files. ILPSim resolves the `#include input_unsigned.s` directive when it loads a source that depends on the shared input module.

## Simulator Configuration

ILPSim supports several execution models. The scheduling model can be selected from `Configure > Set Scheduling`, including sequential, pipeline, Scoreboard, Tomasulo, and reorder-buffer configurations. The default configuration is sufficient for running the exercises, while the other modes can be used to compare execution behavior and inspect instruction-level parallelism.

Simulation speed, the number of cycles performed by the multiple-cycle command, register aliases, processor resources, and other display options can also be adjusted from the `Configure` menu. Reset the simulator after changing execution settings so the selected exercise starts from a clean processor state.

## Source Organization

Each assembly source follows the format accepted by ILPSim:

- the `.data` section declares messages, buffers, and values used by system calls;
- the `.code` section contains the translated program instructions;
- register arguments carry procedure inputs, while `r1` carries input and return values;
- stack space preserves registers across procedure calls;
- system calls provide string input, formatted output, and program termination;
- the final include directive adds the shared unsigned-integer input routine where required.

This organization keeps the C reference and its assembly counterpart together, allowing the control flow and data handling of both representations to be compared within a single source file.
