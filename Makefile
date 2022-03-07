
# Change the example variable to build a different source module (e.g. EXAMPLE=exercice01)
EXAMPLE=exercise01

# Makefile variables 
# Add extra targets to OBJ with space separator e.g. If there is as source file random.c then add random.o to OBJ)
# Add any additional dependancies (header files) to DEPS. e.g. if there is aheader file random.h required by your source modules then add this to DEPS.
CC=gcc
CFLAGS= -O3 -Wextra -fopenmp
NVCC=nvcc
NVCC_FLAGS= -gencode arch=compute_61,code=compute_61
OBJ=$(EXAMPLE).o
DEPS=

# Build rule for object files ($@ is left hand side of rule, $< is first item from the right hand side of rule)
%.o : %.cu $(DEPS)
	$(NVCC) -c -o $@ $< $(NVCC_FLAGS) $(addprefix -Xcompiler ,$(CCFLAGS))

# Make example ($^ is all items from right hand side of the rule)
$(EXAMPLE) : $(OBJ)
	$(NVCC) -o $@ $^ $(NVCC_FLAGS) $(addprefix -Xcompiler ,$(CCFLAGS))

# PHONY prevents make from doing something with a filename called clean
.PHONY : clean
clean:
	rm -rf $(EXAMPLE) $(OBJ)
