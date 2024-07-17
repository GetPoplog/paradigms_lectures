

define Browse_at_loc(file,name);
    let
        name_in  = '$cs287/public_html/' sys_>< file,
        name_out = '/tmp/287_' sys_>< file sys_>< '.htmlo'
    in
        unless (sys_file_exists(name_out)) and
            sysmodtime(name_out) > sysmodtime(name_in)
        then
            notify_user('making new .htmlo file');
            read_html(discin(name_in),name_out);
        endunless;
        vededitat(name_out,identfn,name);
    endlet
enddefine;

define Browse(file);
   Browse_at_loc(file,'');
enddefine;
