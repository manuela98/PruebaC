CC=gcc
CFLAGS=-I.

#Basics
all:
	make tests/test_example_runner.tout

clean:cleancrap cleanexe cleandata
	@echo "Cleaning..."

cleancrap:
	@echo "Cleaning crap..."
	@-find . -name "*~" -exec rm -rf {} \;
	@-find . -name "#" -exec rm -rf {} \;
	@-find . -name "__pycache__" -exec rm -rf {} \; &> /dev/null

cleanexe:
	@echo "Cleaning executable..."
	@rm -rf *.pyc *.out *.exe *.tout *.log 

cleandata:
	@echo "Cleaning data..."
	@rm -rf *.dat 

%.exe:%.opp
	$(CPP) $^ $(LFLAGS) -o $@
	./$@

%.opp:%.cpp %.conf
	$(CPP) -c $(CFLAGS) $< -o $@

%.out:%.o example_module.o
	$(CC) $^ $(LFLAGS) -o $@

%.o:%.c
	$(CC) -c $(CFLAGS) $^ -o $@

commit:
	@echo "Commiting..."
	@-git commit -am "Commit"
	@-git push origin master

status:
	@echo "Git Status..."
	@-git status

pull:
	@-git reset --hard HEAD
	@-git pull

pack:
	@echo "Packing data..."
	@bash $(shell find . -name "pack.sh" |head -n 1) pack

unpack:
	@echo "Unpacking data..."
	@bash $(shell find . -name "pack.sh" |head -n 1) unpack

#C Test
UNITY_ROOT=util/unity
UNITY_FLAGS=-I. -I$(UNITY_ROOT)/src -ftest-coverage -fprofile-arcs $(UNITY_ROOT)/src/unity.c
.PRECIOUS:tests/test_example_runner.c

%.tout:%.c
	$(CC) example_module.c $(^:_runner.c=.c) $^ $(UNITY_FLAGS) -o $@

%_runner.c:%.c
	ruby $(UNITY_ROOT)/auto/generate_test_runner.rb $^ $@


#Specifics of RepoBasics
updaterepo:
	@make -C RepoBasics pull

install:
	@echo "Installing repobasics..."
	@cp -rf example*.* makefile tests build util sonar ..
	@cat .gitignore >> ../.gitignore
	@mv ../sonar/sonar.conf.temp ../sonar/sonar.conf
	@make -C .. pack
	@make -C .. addtorepo
	@make -C .. check

addtorepo:
	@echo "Adding RepoBasics to local repository..."
	@git add -f example*.* makefile tests/* sonar/* sonar/.[a-z]* build/.dir util/* .store/* .store/.[a-z]* .gitignore
	@echo "Now you could commit, eg. make commit"

check:
	@echo "Checking dependencies..."
	@-bash sonar/check.sh

coverage:
	@bash sonar/coverage.sh

sonarscan:
	@bash sonar/sonar.sh

buildwrapper:
	build-wrapper-linux-x86-64 --out-dir build make clean all
