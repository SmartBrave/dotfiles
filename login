#!/usr/bin/expect
set host    [lindex $argv 0]
set user    [lindex $argv 1]
set passwd  [lindex $argv 2]
set relay   [lindex $argv 3]
set normal_args_num 4
set timeout 5

if { $relay != "-" } {
    spawn kinit
    expect {
        "*Password for*" { 
            send "$passwd\r";
        }
    }
    spawn ssh $relay
    expect {
        "*relay_server$*" { send "$host\r" }
    }
} else {
    # spawn ssh -l $user $host
    spawn ssh $user@$host [lrange $argv $normal_args_num end]
    if { [llength $argv] <= $normal_args_num  } {
        expect {
            "*Are you sure you want to continue connecting (yes/no/*" {
                send "yes\r"
                expect {
                    "*\[Pp\]assword*" { send "$passed\r" }
                }
            }
            "*\[Pp\]assword*" { send "$passwd\r" }
            "*" {  }
        }
    } else {
        expect {  }
    }
}

if { [llength $argv] <= $normal_args_num } {
    interact
}
