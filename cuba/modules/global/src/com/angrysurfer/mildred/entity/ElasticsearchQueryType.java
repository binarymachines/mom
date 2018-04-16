package com.angrysurfer.mildred.entity;

import com.haulmont.chile.core.datatypes.impl.EnumClass;

import javax.annotation.Nullable;


public enum ElasticsearchQueryType implements EnumClass<String> {

    match("match"),
    term("term");

    private String id;

    ElasticsearchQueryType(String value) {
        this.id = value;
    }

    public String getId() {
        return id;
    }

    @Nullable
    public static ElasticsearchQueryType fromId(String id) {
        for (ElasticsearchQueryType at : ElasticsearchQueryType.values()) {
            if (at.getId().equals(id)) {
                return at;
            }
        }
        return null;
    }
}