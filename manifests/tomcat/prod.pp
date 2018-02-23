class profile::tomcat::prod {

    include tomcat
    
    tomcat::deploy { "sysfoo" :
        deploy_url          => 'https://2-120669565-gh.circle-artifacts.com/0/tmp/circle-artifacts.8yv2Y1B/sysfoo.war',
        checksum            => 'md5',
        checksum_value      => '40bdb4a6a0abc29c60354b8c5a70622c',
    }



}