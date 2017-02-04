# Bikeworks repo

## Notes
The lines in the examples below that start with "#" are comment
lines...they are not meant to be typed.

## Running the camera program
To run the camera demo, open a terminal window and type the following:

```bash
# move to the bikeworks/bin dir
cd bikeworks/bin

# run the program
sudo ./pycam.py
```

## Running the LED program

```bash
# if you are not in the bikeworks/bin dir
cd bikeworks/bin

# run the program
sudo ./led.py
```

# Git stuff

## Getting the initial clone of the repo
To start out, you need to clone this repo

```bash
cd some/root/directory/that/you/like
git clone https://github.com/rdrdrd/bikeworks.git
cd bikeworks
doStuff
```

## Getting updates
```bash
git pull origin master
```

## Pushing your changes to the repo

```bash
makeFunChanges
git add filesYouChanged
git commit -m'Some meaningful message'
git push origin master
```
