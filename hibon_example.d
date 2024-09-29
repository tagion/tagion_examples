module hibon_example;

@safe:
import std.stdio;
import std.range;
import std.algorithm;
import std.format;
import std.file : remove, exists, readText, writeText  = write;

import tagion.basic.Types : Buffer;
import tagion.hibon;

@recordType("TypeName")
struct MyHiBON {
    string name;
    int count;
    @label("OtherName") long value;
    @label("binary") Buffer buf; 
    mixin HiBONRecord;
}

void main() {
    Buffer buf=[1,2,3,4];
    const my = MyHiBON("my name", 42, -100, buf);
    // Write to a file
    const filename="/tmp/my.hibon";

    if (filename.exists) filename.remove;
    filename.fwrite(my);
    const read_my_hibon = filename.fread!MyHiBON;

    assert(my == read_my_hibon, "Should be the same");
    writefln("Print as pretty json %s", read_my_hibon.toPretty);
    
    // Convert from json to hibon
    const stringified=read_my_hibon.toJSON.toString;
    writefln("stringified=%s", stringified);

    const json_filename="/tmp/my.json";
    if (json_filename.exists) json_filename.remove;
    json_filename.writeText(stringified);

    const read_json = json_filename.readText;
    const read_json_converted_to_document = read_json.toDoc;

    const my_read_hibon_record = MyHiBON(read_json_converted_to_document);

    assert(my_read_hibon_record == my, "Should be the same");
}
