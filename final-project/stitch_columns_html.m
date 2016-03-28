function stitch_columns_html(target_path, col1, col2, col3, col4)
    
    fid = fopen(target_path, 'wt');
    
    fprintf(fid,'<tbody>\n');
    
    format = strcat('<tr><td><img src="%s"', ...
                    '/></td><td><img src="%s"', ...
                    '/></td><td><img src="%s"', ...
                    '/></td><td><img src="%s"', ...
                    '/></td></tr>\n');
                
    for idx = 1:length(col1)
        
        s = sprintf(format,col1{idx},col2{idx},col3{idx},col4{idx});
        fprintf(fid, '%s', s);
    end
    
    fprintf(fid,'</tbody>');
    
    fclose(fid);

end