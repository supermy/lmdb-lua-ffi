local ffi = require "ffi"

_M = {}


local ffi = require "ffi"

ffi.cdef[[ 
typedef struct { 
    char *fpos; 
    void *base; 
    unsigned short handle; 
    short flags; 
    short unget; 
    unsigned long alloc; 
    unsigned short buffincrement; 
} FILE; 

FILE *fopen(const char *filename, const char *mode); 
int fprintf(FILE *stream, const char *format, ...); 
size_t fwrite(
  const void* ptr,
  size_t size,
  size_t nmemb,
  FILE *fp
);
size_t fread(
  void* ptr,
  size_t size,
  size_t nmemb,
  FILE  *fp
);
int feof(FILE *fp);
int fclose(FILE *stream);


// 获取文件大小
int fileSize(FILE* fp)
{
	//获取当前读取文件的位置 进行保存
	int curPos = ftell(fp);
 
	// 跳到文件结尾
	fseek(fp,0,SEEK_END);
 
	//获取文件的大小
	int file_size=ftell(fp);
 
	//恢复文件原来读取的位置
	fseek(fp,curPos,SEEK_SET);
 
	return file_size;
}

]]


function length_of_file(filename)
    local fh = assert(io.open(filename, "rb"))
    local len = assert(fh:seek("end"))
    fh:close()
    return len
end

function file_exists(path)
    local file = io.open(path, "rb")
    if file then file:close() end
    return file ~= nil
end


function _M:readImg(imgfile)
    -- 打开文件
    -- print(imgfile)
    local file = io.open(imgfile, "rb")
    -- 读取所有内容
    local image_bin = file:read("*a")
    -- 关闭文件
    file:close()
    return image_bin;
end


function _M:freadImg(imgfile)
    local fszie = length_of_file(imgfile)
    local file = ffi.C.fopen(imgfile, "rb")
    local buf = ffi.new('uint8_t[?]', fszie)
    local count = ffi.C.fread(buf, 1, fszie, file)
    local val = ffi.new('struct MDB_val', {mv_size=fszie,mv_data=buf})
    ffi.C.fclose(file)
    return val;
end

function _M:fwriteImg(imgfile,mdbVal)
    -- print(tonumber(img.mv_size))
    -- print(tonumber(label.mv_size),label)
    local file = ffi.C.fopen(imgfile, "wb")
    ffi.C.fwrite(mdbVal.mv_data,
        ffi.sizeof("char"),
        mdbVal.mv_size/ffi.sizeof("char"),
        file);
    ffi.C.fclose(file)
end

return _M;