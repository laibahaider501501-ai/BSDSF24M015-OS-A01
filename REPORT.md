# Operating Systems Programming Assignment 01

## Student Information

**Name:** Laiba
**Roll Number:** BSDSF24M015
**Course:** Operating Systems
**Assignment:** Programming Assignment 01

---

# Part 2: Multi-file Project

## Question 1: Explain the linking rule `$(TARGET): $(OBJECTS)`. How does it differ from a Makefile rule that links against a library?

The rule:

```makefile
$(TARGET): $(OBJECTS)
```

means that the final executable depends directly on all the object files listed in `$(OBJECTS)`. The linker takes these object files and combines them to create the final executable.

For example:

```makefile
$(TARGET): $(OBJ)
	$(CC) $(OBJ) -o $(TARGET)
```

In this approach, the source files are first compiled into object files and then all the object files are directly linked together.

A Makefile rule that links against a library is different because the required functions are first placed inside a library and the main program is then linked with that library. For example:

```bash
gcc -Iinclude src/main.c -Llib -lmyutils -o bin/client_static
```

Here, `-Llib` tells the linker where the library is located and `-lmyutils` tells it to link with `libmyutils`.

Therefore, direct multi-file linking combines object files directly, while library linking uses a previously created library containing reusable functions.

---

## Question 2: What is a git tag and why is it useful in a project? What is the difference between a simple tag and an annotated tag?

A Git tag is a name given to a specific commit in a Git repository. It is useful for marking important points in the development history, such as stable versions or releases.

For example:

```bash
git tag v0.1.1-multifile
```

A simple tag is a lightweight reference to a particular commit. It mainly stores the tag name and points directly to a commit.

An annotated tag is a complete Git object that contains additional information such as the tag name, the person who created it, the date, and a message.

For this assignment, annotated tags were used, for example:

```bash
git tag -a v0.4.1-final -m "Final Build"
```

Annotated tags are useful for official releases because they provide additional information about the release.

---

## Question 3: What is the purpose of creating a Release on GitHub? What is the significance of attaching binaries to it?

A GitHub Release provides an official version of a project based on a Git tag. It makes a particular version easy to identify, download, and distribute.

Attaching compiled binaries allows users to download and use the already-built program without compiling the source code themselves.

For example, the assignment used compiled executables and libraries as release assets for the different versions. This demonstrates how a software project can be built, versioned, and distributed.

---

# Part 3: Static Library

## Question 1: Compare the Makefile from Part 2 and Part 3. What are the key differences in the variables and rules that enable the creation of a static library?

In Part 2, the Makefile directly compiled and linked the object files to create the executable.

The main idea was:

```text
Source files → Object files → Executable
```

In Part 3, the utility object files were first combined into a static library called:

```text
lib/libmyutils.a
```

The process became:

```text
Source files → Object files → Static Library
                              ↓
                           Main program
                              ↓
                           Executable
```

The Part 3 Makefile therefore required an additional rule to create the static library. The `ar` command was used to combine the object files into `libmyutils.a`.

The executable was then linked using the library path and library name, such as:

```bash
gcc -Iinclude src/main.c -Llib -lmyutils -o bin/client_static
```

The important difference is that Part 2 directly links the object files, while Part 3 creates a reusable static library and links the client program against it.

---

## Question 2: What is the purpose of the `ar` command? Why is `ranlib` often used immediately after it?

The `ar` command is used to create and modify archive files. In this assignment, it was used to create the static library:

```text
lib/libmyutils.a
```

The object files containing the utility functions were placed inside the archive.

For example:

```bash
ar rcs lib/libmyutils.a obj/mystrfunctions.o obj/myfilefunctions.o
```

The options used with `ar` allow the archive to be created or updated and also create an index of its symbols.

`ranlib` is traditionally used to generate or update the symbol index of an archive. This index helps the linker quickly find the required object files and symbols inside the static library.

Modern versions of `ar` can create this index when the `s` option is used, as in:

```bash
ar rcs
```

Therefore, a separate `ranlib` command is often unnecessary when `ar` is used with the `s` option.

---

## Question 3: When you run `nm` on your `client_static` executable, are the symbols for functions like `mystrlen` present? What does this tell you about how static linking works?

Yes. The functions from the static library that are required by the program can appear as symbols in the final `client_static` executable.

For example, the `mystrlen` function is part of `libmyutils.a` and is required by the client program. During static linking, the required code from the library is copied into the executable.

This shows that static linking incorporates the required library code into the final executable. Therefore, the executable contains the required implementation of the library functions and does not need to load the static library separately when it runs.

---

# Part 4: Dynamic Library

## Question 1: What is Position-Independent Code (`-fPIC`) and why is it a fundamental requirement for creating shared libraries?

Position-Independent Code, or PIC, is code that can execute correctly regardless of the memory address where it is loaded.

The `-fPIC` option tells GCC to generate position-independent code.

For example:

```bash
gcc -fPIC -c src/mystrfunctions.c -o obj/mystrfunctions.o
```

and:

```bash
gcc -fPIC -c src/myfilefunctions.c -o obj/myfilefunctions.o
```

This is important for shared libraries because a shared library can be loaded into different memory locations by different processes.

Using position-independent code allows the same shared library to be loaded and used without requiring its machine code to be modified for a particular memory address.

---

## Question 2: Explain the difference in file size between your static and dynamic clients. Why does this difference exist?

The static and dynamic clients can have different file sizes because of the way the library code is linked.

With static linking, the required library code is copied into the executable:

```text
client_static
    + library code
```

Therefore, the executable contains the required library implementations.

With dynamic linking, the executable contains references to the shared library instead of copying the complete library code into itself:

```text
client_dynamic → libmyutils.so
```

The shared library remains as a separate `.so` file and is loaded when the program runs.

Therefore, the dynamic client can be smaller because the library code is kept in the separate shared library.

The exact size difference depends on the compiled program and system.

---

## Question 3: What is the `LD_LIBRARY_PATH` environment variable? Why was it necessary to set it for your program to run, and what does this tell you about the responsibilities of the operating system's dynamic loader?

`LD_LIBRARY_PATH` is an environment variable that tells the dynamic loader additional directories in which it should search for shared libraries.

The custom shared library for this assignment was located inside the project's `lib` directory:

```text
lib/libmyutils.so
```

The operating system's dynamic loader does not automatically search the project's local `lib` directory. Therefore, the following command was used:

```bash
export LD_LIBRARY_PATH=$PWD/lib:$LD_LIBRARY_PATH
```

After setting this variable, the dynamic executable could find `libmyutils.so` and run successfully.

The `ldd` command can be used to inspect the shared-library dependencies of the executable:

```bash
ldd bin/client_dynamic
```

This demonstrates that the dynamic loader is responsible for locating and loading the required shared libraries when a dynamically linked program starts.

---

# Part 5: Man Pages and Installation

In Part 5, Linux man pages were created for the library functions. The pages were placed in the `man/man3` directory and included standard sections such as:

* `.TH`
* `.SH NAME`
* `.SH SYNOPSIS`
* `.SH DESCRIPTION`
* `.SH AUTHOR`o


An `install` target was also added to the Makefile.

The installation command:

```bash
sudo make install
```

installs the client executable and the man pages into the system directories.

The installed program can then be executed using:

```bash
client
```

and the manual pages can be accessed using commands such as:

```bash
man mystrlen
```

This provides users with a standard Linux method for accessing documentation.

---

# Final Summary

This assignment demonstrated the complete development workflow for a multi-file C project.

The project was first developed as a multi-file program and then converted into a reusable static library and a dynamic library. Makefiles were used to automate compilation and linking.

Git branches were used to separate the different development stages:

```text
multifile-build
static-build
dynamic-build
man-pages
```

Git tags were used to identify important versions of the project, and GitHub Releases were used to distribute the compiled project assets.

The project also demonstrated binary-analysis tools such as:

```text
ar
nm
readelf
ldd
```

Finally, Linux man pages and a Makefile installation target were added to provide documentation and a simple installation process.

Overall, the assignment provided practical experience with C compilation, object files, static and dynamic linking, shared libraries, the dynamic loader, Makefiles, Linux documentation, and Git/GitHub version control.
