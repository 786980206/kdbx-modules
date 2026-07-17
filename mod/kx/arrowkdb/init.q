// \d .arrowkdb

lib:hsym`$":::arrowkdb";
// datatype constructors:
// concrete datatypes:
dt.na:lib 2:(`null;1);
dt.boolean:lib 2:(`boolean;1);
dt.int8:lib 2:(`int8;1);
dt.int16:lib 2:(`int16;1);
dt.int32:lib 2:(`int32;1);
dt.int64:lib 2:(`int64;1);
dt.uint8:lib 2:(`uint8;1);
dt.uint16:lib 2:(`uint16;1);
dt.uint32:lib 2:(`uint32;1);
dt.uint64:lib 2:(`uint64;1);
dt.float16:lib 2:(`float16;1);
dt.float32:lib 2:(`float32;1);
dt.float64:lib 2:(`float64;1);
dt.date32:lib 2:(`date32;1);
dt.date64:lib 2:(`date64;1);
dt.month_interval:lib 2:(`month_interval;1);
dt.day_time_interval:lib 2:(`day_time_interval;1);
dt.binary:lib 2:(`binary;1);
dt.utf8:lib 2:(`utf8;1);
dt.large_binary:lib 2:(`large_binary;1);
dt.large_utf8:lib 2:(`large_utf8;1);
// parameterized datatypes:
dt.time32:lib 2:(`time32;1);
dt.time64:lib 2:(`time64;1);
dt.timestamp:lib 2:(`timestamp;1);
dt.duration:lib 2:(`duration;1);
dt.fixed_size_binary:lib 2:(`fixed_size_binary;1);
dt.decimal128:lib 2:(`decimal128;2);
// nested datatype constructors:
// from datatypes:
dt.list:lib 2:(`list;1);
dt.large_list:lib 2:(`large_list;1);
dt.fixed_size_list:lib 2:(`fixed_size_list;2);
dt.map:lib 2:(`map;2);
dt.dictionary:lib 2:(`dictionary;2);
// from fields:
dt.struct:lib 2:(`struct_;1);
dt.sparse_union:lib 2:(`sparse_union;1);
dt.dense_union:lib 2:(`dense_union;1);
// infer from kdb list:
dt.inferDatatype:lib 2:(`inferDatatype;1);

// datatype inspection:
dt.datatypeName:lib 2:(`datatypeName;1);
dt.getTimeUnit:lib 2:(`getTimeUnit;1);
dt.getByteWidth:lib 2:(`getByteWidth;1);
dt.getListSize:lib 2:(`getListSize;1);
dt.getPrecisionScale:lib 2:(`getPrecisionScale;1);
dt.getListDatatype:lib 2:(`getListDatatype;1);
dt.getMapDatatypes:lib 2:(`getMapDatatypes;1);
dt.getDictionaryDatatypes:lib 2:(`getDictionaryDatatypes;1);
dt.getChildFields:lib 2:(`getChildFields;1);

// datatype management:
dt.printDatatype_:lib 2:(`printDatatype;1);
dt.printDatatype:{[x] -1 dt.printDatatype_[x];};
dt.listDatatypes:lib 2:(`listDatatypes;1);
dt.removeDatatype:lib 2:(`removeDatatype;1);
dt.equalDatatypes:lib 2:(`equalDatatypes;2);


//field constructor:
fd.field:lib 2:(`field;2);

// field inspection:
fd.fieldName:lib 2:(`fieldName;1);
fd.fieldDatatype:lib 2:(`fieldDatatype;1);

// field management:
fd.printField_:lib 2:(`printField;1);
fd.printField:{[x] -1 fd.printField_[x];};
fd.listFields:lib 2:(`listFields;1);
fd.removeField:lib 2:(`removeField;1);
fd.equalFields:lib 2:(`equalFields;2);


// schema constructors:
// from fields:
sc.schema:lib 2:(`schema;1);
// inferred from table:
sc.inferSchema:lib 2:(`inferSchema;1);

// schema inspection:
sc.schemaFields:lib 2:(`schemaFields;1);

// schema management
sc.printSchema_:lib 2:(`printSchema;1);
sc.printSchema:{[x] -1 sc.printSchema_[x];};
sc.listSchemas:lib 2:(`listSchemas;1);
sc.removeSchema:lib 2:(`removeSchema;1);
sc.equalSchemas:lib 2:(`equalSchemas;2);


// array data
ar.prettyPrintArray_:lib 2:(`prettyPrintArray;3);
ar.prettyPrintArray:{[x;y;z] -1 ar.prettyPrintArray_[x;y;z];};
ar.prettyPrintArrayFromList:{[list;options] ar.prettyPrintArray[dt.inferDatatype[list];list;options]};


// table data
tb.prettyPrintTable_:lib 2:(`prettyPrintTable;3);
tb.prettyPrintTable:{[x;y;z] -1 tb.prettyPrintTable_[x;y;z];};
tb.prettyPrintTableFromTable:{[table;options] tb.prettyPrintTable[sc.inferSchema[table];value flip table;options]};

// ORC files
orc.writeOrc:lib 2:(`writeORC;4);
orc.writeOrcFromTable:{[filename;table;options] orc.writeOrc[filename;sc.inferSchema[table];value flip table;options]};
orc.readOrcSchema:lib 2:(`readORCSchema;1);
orc.readOrcData:lib 2:(`readORCData;2);
orc.readOrcToTable:{[filename;options]
    fields:fd.fieldName each sc.schemaFields[orc.readOrcSchema[filename]];
    data:orc.readOrcData[filename;options];
    $[1~options`WITH_NULL_BITMAP;
        (flip fields!first data;flip fields!last data);
        flip fields!data
        ]
    };

// parquet files
pq.writeParquet:lib 2:(`writeParquet;4);
pq.writeParquetFromTable:{[filename;table;options] pq.writeParquet[filename;sc.inferSchema[table];value flip table;options]};
pq.readParquetSchema:lib 2:(`readParquetSchema;1);
pq.readParquetData:lib 2:(`readParquetData;2);
pq.readParquetToTable:{[filename;options] 
    fields:fd.fieldName each sc.schemaFields[pq.readParquetSchema[filename]];
    data:pq.readParquetData[filename;options];
    $[1~options`WITH_NULL_BITMAP;
        (flip fields!first data;flip fields!last data);
        flip fields!data
        ]
    };
pq.readParquetColumn:lib 2:(`readParquetColumn;3);
pq.readParquetNumRowGroups:lib 2:(`readParquetNumRowGroups;1);
pq.readParquetRowGroups:lib 2:(`readParquetRowGroups;4);
pq.readParquetRowGroupsToTable:{[filename;row_groups;columns;options]
    fields:fd.fieldName each sc.schemaFields[pq.readParquetSchema[filename]](columns);
    data:pq.readParquetRowGroups[filename;row_groups;columns;options];
    $[1~options`WITH_NULL_BITMAP;
        (flip fields!first data;flip fields!last data);
        flip fields!data
        ]
    };

// arrow files
ipc.writeArrow:lib 2:(`writeArrow;4);
ipc.writeArrowFromTable:{[filename;table;options] ipc.writeArrow[filename;sc.inferSchema[table];value flip table;options]};
ipc.readArrowSchema:lib 2:(`readArrowSchema;1);
ipc.readArrowData:lib 2:(`readArrowData;2);
ipc.readArrowToTable:{[filename;options]
    fields:fd.fieldName each sc.schemaFields[ipc.readArrowSchema[filename]];
    data:ipc.readArrowData[filename;options];
    $[1~options`WITH_NULL_BITMAP;
        (flip fields!first data;flip fields!last data);
        flip fields!data
        ]
    };


// arrow streams
ipc.serializeArrow:lib 2:(`serializeArrow;3);
ipc.serializeArrowFromTable:{[table;options] ipc.serializeArrow[sc.inferSchema[table];value flip table;options]};
ipc.parseArrowSchema:lib 2:(`parseArrowSchema;1);
ipc.parseArrowData:lib 2:(`parseArrowData;2);
ipc.parseArrowToTable:{[serialized;options] 
    fields:fd.fieldName each sc.schemaFields[ipc.parseArrowSchema[serialized]];
    data:ipc.parseArrowData[serialized;options];
    $[1~options`WITH_NULL_BITMAP;
        (flip fields!first data;flip fields!last data);
        flip fields!data
        ]
    };


// utils
util.buildInfo:lib 2:(`buildInfo;1);
util.init:lib 2:(`init;1);


// testing
ts.writeReadArray:lib 2:(`writeReadArray;3);
ts.writeReadTable:lib 2:(`writeReadTable;3);


// initialise
util.init[];

// export all
export:.z.m;