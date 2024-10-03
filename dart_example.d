module dart_example;

@safe:
import std.stdio;
import std.range;
import std.algorithm;
import std.format;
import std.file : remove, exists, readText, writeText  = write;

import tagion.basic.Types : Buffer;
import tagion.hibon;
import tagion.dart;
import tagion.crypto;
import tagion.communication;

@recordType("TypeName")
struct MyHiBON {
    string name;
    int count;
    @label("OtherName") long value;
    @label("binary") Buffer buf; 
    mixin HiBONRecord;
}

void main() {

    auto net=new StdSecureNet;
    net.generateKeyPair("Very secret password");

    const filename="/tmp/my.drt";
    // Create a new dart db 
    if (filename.exists) filename.remove;
    DART.create(filename, net);

    /// Open the db
    auto db=new DART(net, filename);

    DARTIndex[] dart_indices;
    {
        Buffer buf=[1,2,3,4];
        const my1 = MyHiBON("my name", 42, -100, buf);
        const my2 = MyHiBON("my name", 42, 100, buf);
        
        dart_indices~=net.dartIndex(my1);
        dart_indices~=net.dartIndex(my2);

        // Create a recorder;
        auto rec = db.recorder;
        rec.add(my1);
        rec.add(my2);
        const bullseye=db.modify(rec);
        writefln("bullseye=%(%02x%)", bullseye);
    }

    writefln("dart_indices= %(%(%02x%) %)", dart_indices);

    const hirpc = HiRPC(net);
    /// DART dartRead RPC sender
    const sender = CRUD.dartRead(dart_indices, hirpc);
    writefln("dartRead RPC=%s", sender.toPretty);
    /// DART receiver
    const receiver = hirpc.receive(sender); 
    const response = db(receiver);

    writefln("response=%s", response.toPretty);

    auto factory = RecordFactory(net);
    auto recorder = factory.recorder(response.result);
    writefln("Recorder dart-indices=%(%(%02x%) %)",recorder[].map!(a => a.dart_index));
    writefln("archives =%-(%s\n%)",recorder[].map!(a => a.filed.toPretty));
}
