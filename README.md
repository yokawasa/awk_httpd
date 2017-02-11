# AWK HTTPD
GNU AWK HTTP Server Scripts 

![AWK_HTTPD SCREENSHOT](https://github.com/yokawasa/awk_httpd/raw/master/img/awkhttpd.png)

## Install GNU AWK (if needed)

Please install GNU AWK if not yet installed on your environment

```
# for Mac OS
brew install gawk

# for Ubuntu,Debian apt users
sudo apt-get install gawk

# for CentOS,Fedora,Oracle Linux,Red Hat Enterprise Linux
sudo yum install gawk
```

## Usage

Assuming GNU AWK is installed on your environment, you're ready to run awk_httpd. Simply checkout awk_httpd repository and run the httpd. Default port and document root directory are 8080 and ./ respectively.

```
$ git clone git@github.com:yokawasa/awk_httpd.git  
Initialized empty Git repository in github/awk_httpd.git/
remote: Counting objects: 45, done.
remote: Compressing objects: 100% (44/44), done.
remote: Total 45 (delta 11), reused 0 (delta 0)
Receiving objects: 100% (45/45), 13.99 KiB, done.
Resolving deltas: 100% (11/11), done

$ cd awk_httpd

$ ls -1 
LICENSE
README.md
httpd.awk
httpd.igawk
img
pages

$ gawk -f ./httpd.awk
$ curl http://localhost:8080/pages/
```

There is an igawk version GNU AWK HTTPD, httpd.igwk. This is basically the same as httpd.awk except parameter options that you can give GNU AWK HTTPD to change default configuration such as port and root document directory


```
$ igawk -f httpd.igawk -h
Usage: httpd.igawk [-p port] [-d docroot] [-h]
Options:
  -p port    : define server port (default: 8080)
  -d docroot : define document root (default: "./")
  -h         : list available command options

$ igawk -f httpd.igawk -p 8888 -d ./pages
$ curl http://localhost:8888/pages/
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yokawasa/awk_httpd.
