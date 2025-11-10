{
    "patcher": {
        "fileversion": 1,
        "appversion": {
            "major": 8,
            "minor": 5,
            "revision": 5,
            "architecture": "x64",
            "modernui": 1
        },
        "classnamespace": "box",
        "rect": [
            85.0,
            104.0,
            640.0,
            480.0
        ],
        "bglocked": 0,
        "openinpresentation": 0,
        "default_fontsize": 12.0,
        "default_fontface": 0,
        "default_fontname": "Arial",
        "gridonopen": 1,
        "gridsize": [
            15.0,
            15.0
        ],
        "gridsnaponopen": 1,
        "objectsnaponopen": 1,
        "statusbarvisible": 2,
        "toolbarvisible": 1,
        "lefttoolbarpinned": 0,
        "toptoolbarpinned": 0,
        "righttoolbarpinned": 0,
        "bottomtoolbarpinned": 0,
        "toolbars_unpinned_last_save": 0,
        "tallnewobj": 0,
        "boxanimatetime": 200,
        "enablehscroll": 1,
        "enablevscroll": 1,
        "devicewidth": 0.0,
        "description": "",
        "digest": "",
        "tags": "",
        "style": "",
        "subpatcher_template": "",
        "assistshowspatchername": 0,
        "boxes": [
            {
                "box": {
                    "id": "obj-1",
                    "maxclass": "comment",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "patching_rect": [
                        50.0,
                        10.0,
                        350.0,
                        100.0
                    ],
                    "text": "Faust generated RNBO patch, Copyright (c) 2023-2025 Grame",
                    "fontsize": 16
                }
            },
            {
                "box": {
                    "id": "obj-2",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 8,
                    "patching_rect": [
                        48.0,
                        48.0,
                        66.0,
                        22.0
                    ],
                    "patcher": {
                        "fileversion": 1,
                        "appversion": {
                            "major": 8,
                            "minor": 5,
                            "revision": 5,
                            "architecture": "x64",
                            "modernui": 1
                        },
                        "classnamespace": "rnbo",
                        "rect": [
                            85.0,
                            104.0,
                            640.0,
                            480.0
                        ],
                        "bglocked": 0,
                        "openinpresentation": 0,
                        "default_fontsize": 12.0,
                        "default_fontface": 0,
                        "default_fontname": "Arial",
                        "gridonopen": 1,
                        "gridsize": [
                            15.0,
                            15.0
                        ],
                        "gridsnaponopen": 1,
                        "objectsnaponopen": 1,
                        "statusbarvisible": 2,
                        "toolbarvisible": 1,
                        "lefttoolbarpinned": 0,
                        "toptoolbarpinned": 0,
                        "righttoolbarpinned": 0,
                        "bottomtoolbarpinned": 0,
                        "toolbars_unpinned_last_save": 0,
                        "tallnewobj": 0,
                        "boxanimatetime": 200,
                        "enablehscroll": 1,
                        "enablevscroll": 1,
                        "devicewidth": 0.0,
                        "description": "",
                        "digest": "",
                        "tags": "",
                        "style": "",
                        "subpatcher_template": "",
                        "assistshowspatchername": 0,
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-1",
                                    "maxclass": "codebox~",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        500.0,
                                        500.0,
                                        400.0,
                                        200.0
                                    ],
                                    "code": "// Code generated with Faust version 2.79.4\r\n// Compilation options: -lang codebox -ec -ct 1 -es 1 -mcd 16 -mdd 1024 -mdy 33 -double -ftz 0 \r\n// Additional functions\r\n// Params\r\n// Globals\r\n// Fields\r\n@state fSampleRate_cb : Int = 0;\r\n@state fUpdated : Int = 0;\r\n// Init\r\nfunction dspsetup() {\r\n\tfUpdated = true;\r\n\tfSampleRate_cb = samplerate();\r\n}\r\n// Control\r\nfunction control() {\r\n}\r\n// Update parameters\r\nfunction update() {\r\n\tif (fUpdated) { fUpdated = false; control(); }\r\n}\r\n// Compute one frame\r\nfunction compute(i0,i1,i2,i3,i4,i5) {\r\n\tlet input0_cb : number = i0;\r\n\tlet input1_cb : number = i1;\r\n\tlet input2_cb : number = i2;\r\n\tlet input3_cb : number = i3;\r\n\tlet input4_cb : number = i4;\r\n\tlet input5_cb : number = i5;\r\n\tlet output0_cb : number = 0;\r\n\tlet output1_cb : number = 0;\r\n\tlet output2_cb : number = 0;\r\n\tlet output3_cb : number = 0;\r\n\tlet output4_cb : number = 0;\r\n\tlet output5_cb : number = 0;\r\n\toutput0_cb = input0_cb;\r\n\toutput1_cb = input1_cb;\r\n\toutput2_cb = input2_cb;\r\n\toutput3_cb = input3_cb;\r\n\toutput4_cb = input4_cb;\r\n\toutput5_cb = input5_cb;\r\n\treturn [output0_cb,output1_cb,output2_cb,output3_cb,output4_cb,output5_cb];\r\n}\r\n// Update parameters\r\nupdate();\r\n// Compute one frame\r\noutputs = compute(in1,in2,in3,in4,in5,in6);\r\n// Write the outputs: audio ones and bargraph as additional audio signals\r\nout1 = outputs[0];\r\nout2 = outputs[1];\r\nout3 = outputs[2];\r\nout4 = outputs[3];\r\nout5 = outputs[4];\r\nout6 = outputs[5];\r\n",
                                    "outlettype": [
                                        ""
                                    ],
                                    "rnbo_classname": "codebox~",
                                    "rnbo_extra_attributes": {
                                        "code": "// Code generated with Faust version 2.79.4\r\n// Compilation options: -lang codebox -ec -ct 1 -es 1 -mcd 16 -mdd 1024 -mdy 33 -double -ftz 0 \r\n// Additional functions\r\n// Params\r\n// Globals\r\n// Fields\r\n@state fSampleRate_cb : Int = 0;\r\n@state fUpdated : Int = 0;\r\n// Init\r\nfunction dspsetup() {\r\n\tfUpdated = true;\r\n\tfSampleRate_cb = samplerate();\r\n}\r\n// Control\r\nfunction control() {\r\n}\r\n// Update parameters\r\nfunction update() {\r\n\tif (fUpdated) { fUpdated = false; control(); }\r\n}\r\n// Compute one frame\r\nfunction compute(i0,i1,i2,i3,i4,i5) {\r\n\tlet input0_cb : number = i0;\r\n\tlet input1_cb : number = i1;\r\n\tlet input2_cb : number = i2;\r\n\tlet input3_cb : number = i3;\r\n\tlet input4_cb : number = i4;\r\n\tlet input5_cb : number = i5;\r\n\tlet output0_cb : number = 0;\r\n\tlet output1_cb : number = 0;\r\n\tlet output2_cb : number = 0;\r\n\tlet output3_cb : number = 0;\r\n\tlet output4_cb : number = 0;\r\n\tlet output5_cb : number = 0;\r\n\toutput0_cb = input0_cb;\r\n\toutput1_cb = input1_cb;\r\n\toutput2_cb = input2_cb;\r\n\toutput3_cb = input3_cb;\r\n\toutput4_cb = input4_cb;\r\n\toutput5_cb = input5_cb;\r\n\treturn [output0_cb,output1_cb,output2_cb,output3_cb,output4_cb,output5_cb];\r\n}\r\n// Update parameters\r\nupdate();\r\n// Compute one frame\r\noutputs = compute(in1,in2,in3,in4,in5,in6);\r\n// Write the outputs: audio ones and bargraph as additional audio signals\r\nout1 = outputs[0];\r\nout2 = outputs[1];\r\nout3 = outputs[2];\r\nout4 = outputs[3];\r\nout5 = outputs[4];\r\nout6 = outputs[5];\r\n",
                                        "hot": 0
                                    }
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-2",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        48.0,
                                        48.0,
                                        66.0,
                                        22.0
                                    ],
                                    "text": "in~ 1",
                                    "outlettype": [
                                        ""
                                    ],
                                    "rnbo_classname": "in~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-3",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        192.0,
                                        48.0,
                                        66.0,
                                        22.0
                                    ],
                                    "text": "in~ 2",
                                    "outlettype": [
                                        ""
                                    ],
                                    "rnbo_classname": "in~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        336.0,
                                        48.0,
                                        66.0,
                                        22.0
                                    ],
                                    "text": "in~ 3",
                                    "outlettype": [
                                        ""
                                    ],
                                    "rnbo_classname": "in~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        480.0,
                                        48.0,
                                        66.0,
                                        22.0
                                    ],
                                    "text": "in~ 4",
                                    "outlettype": [
                                        ""
                                    ],
                                    "rnbo_classname": "in~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-6",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        48.0,
                                        120.0,
                                        66.0,
                                        22.0
                                    ],
                                    "text": "in~ 5",
                                    "outlettype": [
                                        ""
                                    ],
                                    "rnbo_classname": "in~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-7",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        192.0,
                                        120.0,
                                        66.0,
                                        22.0
                                    ],
                                    "text": "in~ 6",
                                    "outlettype": [
                                        ""
                                    ],
                                    "rnbo_classname": "in~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        336.0,
                                        120.0,
                                        66.0,
                                        22.0
                                    ],
                                    "text": "out~ 1",
                                    "outlettype": [
                                        ""
                                    ],
                                    "rnbo_classname": "out~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-9",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        480.0,
                                        120.0,
                                        66.0,
                                        22.0
                                    ],
                                    "text": "out~ 2",
                                    "outlettype": [
                                        ""
                                    ],
                                    "rnbo_classname": "out~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-10",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        48.0,
                                        192.0,
                                        66.0,
                                        22.0
                                    ],
                                    "text": "out~ 3",
                                    "outlettype": [
                                        ""
                                    ],
                                    "rnbo_classname": "out~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-11",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        192.0,
                                        192.0,
                                        66.0,
                                        22.0
                                    ],
                                    "text": "out~ 4",
                                    "outlettype": [
                                        ""
                                    ],
                                    "rnbo_classname": "out~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-12",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        336.0,
                                        192.0,
                                        66.0,
                                        22.0
                                    ],
                                    "text": "out~ 5",
                                    "outlettype": [
                                        ""
                                    ],
                                    "rnbo_classname": "out~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        480.0,
                                        192.0,
                                        66.0,
                                        22.0
                                    ],
                                    "text": "out~ 6",
                                    "outlettype": [
                                        ""
                                    ],
                                    "rnbo_classname": "out~"
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "source": [
                                        "obj-2",
                                        0
                                    ],
                                    "destination": [
                                        "obj-1",
                                        0
                                    ],
                                    "order": 0
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-3",
                                        0
                                    ],
                                    "destination": [
                                        "obj-1",
                                        1
                                    ],
                                    "order": 0
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        0
                                    ],
                                    "destination": [
                                        "obj-1",
                                        2
                                    ],
                                    "order": 0
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-5",
                                        0
                                    ],
                                    "destination": [
                                        "obj-1",
                                        3
                                    ],
                                    "order": 0
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
                                    ],
                                    "destination": [
                                        "obj-1",
                                        4
                                    ],
                                    "order": 0
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-7",
                                        0
                                    ],
                                    "destination": [
                                        "obj-1",
                                        5
                                    ],
                                    "order": 0
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-1",
                                        0
                                    ],
                                    "destination": [
                                        "obj-8",
                                        0
                                    ],
                                    "order": 0
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-1",
                                        1
                                    ],
                                    "destination": [
                                        "obj-9",
                                        0
                                    ],
                                    "order": 0
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-1",
                                        2
                                    ],
                                    "destination": [
                                        "obj-10",
                                        0
                                    ],
                                    "order": 0
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-1",
                                        3
                                    ],
                                    "destination": [
                                        "obj-11",
                                        0
                                    ],
                                    "order": 0
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-1",
                                        4
                                    ],
                                    "destination": [
                                        "obj-12",
                                        0
                                    ],
                                    "order": 0
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-1",
                                        5
                                    ],
                                    "destination": [
                                        "obj-13",
                                        0
                                    ],
                                    "order": 0
                                }
                            }
                        ],
                        "dependency_cache": [],
                        "autosave": 0
                    },
                    "text": "rnbo~",
                    "outlettype": [
                        ""
                    ],
                    "inletInfo": {
                        "IOInfo": [
                            {
                                "comment": "",
                                "index": 1,
                                "tag": "in1",
                                "type": "signal"
                            },
                            {
                                "comment": "",
                                "index": 2,
                                "tag": "in2",
                                "type": "signal"
                            },
                            {
                                "comment": "",
                                "index": 3,
                                "tag": "in3",
                                "type": "signal"
                            },
                            {
                                "comment": "",
                                "index": 4,
                                "tag": "in4",
                                "type": "signal"
                            },
                            {
                                "comment": "",
                                "index": 5,
                                "tag": "in5",
                                "type": "signal"
                            },
                            {
                                "comment": "",
                                "index": 6,
                                "tag": "in6",
                                "type": "signal"
                            }
                        ]
                    },
                    "outletInfo": {
                        "IOInfo": [
                            {
                                "comment": "",
                                "index": 1,
                                "tag": "out1",
                                "type": "signal"
                            },
                            {
                                "comment": "",
                                "index": 2,
                                "tag": "out2",
                                "type": "signal"
                            },
                            {
                                "comment": "",
                                "index": 3,
                                "tag": "out3",
                                "type": "signal"
                            },
                            {
                                "comment": "",
                                "index": 4,
                                "tag": "out4",
                                "type": "signal"
                            },
                            {
                                "comment": "",
                                "index": 5,
                                "tag": "out5",
                                "type": "signal"
                            },
                            {
                                "comment": "",
                                "index": 6,
                                "tag": "out6",
                                "type": "signal"
                            }
                        ]
                    },
                    "title": "untitled",
                    "saved_object_attributes": {
                        "optimization": "O3",
                        "title": "untitled",
                        "dumpoutlet": 1
                    }
                }
            },
            {
                "box": {
                    "id": "obj-3",
                    "maxclass": "toggle",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        192.0,
                        48.0,
                        24.0,
                        24.0
                    ],
                    "text": "toggle",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-4",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "patching_rect": [
                        336.0,
                        48.0,
                        66.0,
                        22.0
                    ],
                    "text": "dac~ 1 2 3 4 5 6",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-5",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 6,
                    "patching_rect": [
                        480.0,
                        48.0,
                        66.0,
                        22.0
                    ],
                    "text": "adc~ 1 2 3 4 5 6",
                    "outlettype": [
                        ""
                    ]
                }
            }
        ],
        "lines": [
            {
                "patchline": {
                    "source": [
                        "obj-3",
                        0
                    ],
                    "destination": [
                        "obj-4",
                        0
                    ],
                    "order": 0
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-2",
                        0
                    ],
                    "destination": [
                        "obj-4",
                        0
                    ],
                    "order": 0
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-2",
                        1
                    ],
                    "destination": [
                        "obj-4",
                        1
                    ],
                    "order": 1
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-2",
                        2
                    ],
                    "destination": [
                        "obj-4",
                        2
                    ],
                    "order": 2
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-2",
                        3
                    ],
                    "destination": [
                        "obj-4",
                        3
                    ],
                    "order": 3
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-2",
                        4
                    ],
                    "destination": [
                        "obj-4",
                        4
                    ],
                    "order": 4
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-2",
                        5
                    ],
                    "destination": [
                        "obj-4",
                        5
                    ],
                    "order": 5
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-5",
                        0
                    ],
                    "destination": [
                        "obj-2",
                        0
                    ],
                    "order": 0
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-5",
                        1
                    ],
                    "destination": [
                        "obj-2",
                        1
                    ],
                    "order": 1
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-5",
                        2
                    ],
                    "destination": [
                        "obj-2",
                        2
                    ],
                    "order": 2
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-5",
                        3
                    ],
                    "destination": [
                        "obj-2",
                        3
                    ],
                    "order": 3
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-5",
                        4
                    ],
                    "destination": [
                        "obj-2",
                        4
                    ],
                    "order": 4
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-5",
                        5
                    ],
                    "destination": [
                        "obj-2",
                        5
                    ],
                    "order": 5
                }
            }
        ],
        "dependency_cache": [],
        "autosave": 0
    }
}