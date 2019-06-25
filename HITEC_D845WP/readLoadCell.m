function out = readLoadCell()
    global btModule;
    out = fscanf(btModule, '%f');
end