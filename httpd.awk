#! /usr/bin/gawk -f

#
# httpd.awk
# Simple HTTP Server Written By GNU AWK
#

BEGIN {
    port = "8080";
    docroot = "./";
    http_service = "/inet/tcp/" port "/0/0";
    RS = ORS = "\r\n";
    for (;;) {
       if ((http_service |& getline reqline) > 0) {
            request_handler(http_service, reqline, docroot);
        }
       close(http_service);
    }
}

function request_handler(http_service,reqline, docroot) {
    # parse request line
    if ( split(reqline, t, " ") !=3 ) {
        show_error(http_service, 400, "Bad Request");
        return 1;
    }
    req_method = t[1];
    req_uri = (index(t[2], "/")==1) ? substr(t[2],2) : t[2];
    if (req_method != "GET" ) {
        show_error(http_service, 405, "Method Not Allowed");
       return 1;
    }
    # set path and query string
    path = docroot req_uri;
    n = split(path,tt,"?");
    if (n >=2 ) {
        path = tt[1];
        ENVIRON["QUERY_STRING"] = tt[2];
    }
    # path should end with "/" if it's directory.
    if(dir_exists(path)) {
        if (substr(path,length(path)) != "/") {
            path = path "/";
        }
        # set default file
        path = path "index.html";
    }

    # check if file exists
    if (!file_exists(path)) {
        show_error(http_service, 404, "Not Found");
       return 1;
    }
    show_page(http_service, path);
    return 0;
}

function file_exists(path) {
    cmd ="if [ -f " path " ]; then echo OK; fi";
    exist = 0;
    if ( (cmd |getline res) > 0) {
        gsub("\n","", res);
        if (res == "OK") {
            exist = 1;
        }
    }
    close(cmd);
    return exist;
}

function dir_exists(path) {
    cmd ="if [ -d " path " ]; then echo OK; fi";
    exist = 0;
    if ( (cmd |getline res) > 0) {
        gsub("\n","", res);
        if (res == "OK") {
            exist = 1;
        }
    }
    close(cmd);
    return exist;
}

function file_read(file) {
    buf = "";
    while (getline < file > 0) {
         buf = buf $0;
    }
    close(file);
    return buf;
}

function find_mime_type(path) {
    mime_type = "application/ocet-stream"; # default mime type
    n = split(path, t, "/");
    if (n >=2 ) {
        filename = t[n];
        m = split(filename, tt, ".");
        if (m >=2 ) {
            ext = tolower(tt[m]);
            if (ext == "html" || ext == "htm") {
                mime_type = "text/html";
            }else if (ext == "css" ) {
                mime_type = "text/css";
            }else if (ext == "txt" || ext == "text" ) {
                mime_type = "text/plain";
            }
        }
    }
    return mime_type;
}

function show_page( http_service,path) {
    outbuf = file_read(path);
    mime_type = find_mime_type(path);
    content_len = length(buf);
    print_output(http_service,200,"OK",outbuf,mime_type,content_len);
}

function show_error( http_service, errcode, reason) {
    outbuf = "<h1>" reason "</h1>";
    mime_type = "text/html";
    content_len = length(buf);
    print_output(http_service,errcode,reason,outbuf,mime_type,content_len);
}

function print_output( http_service,code,reason,outbuf,mime_type,content_len) {
    print "HTTP/1.x " code " " reason |& http_service;
    print "Content-type: " mime_type |& http_service;
    print "Content-Length: " content_len |& http_service;
    print ""                        |& http_service;
    print outbuf |& http_service;
}
