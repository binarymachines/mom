package com.angrysurfer.mildred.entity;

import com.haulmont.chile.core.datatypes.impl.EnumClass;

import javax.annotation.Nullable;


public enum ElasticsearchQuerySection implements EnumClass<String> {

    must("must"),
    must_not("must_not"),
    should("should"),
    should_not("should_not");

    private String id;

    ElasticsearchQuerySection(String value) {
        this.id = value;
    }

    public String getId() {
        return id;
    }

    @Nullable
    public static ElasticsearchQuerySection fromId(String id) {
        for (ElasticsearchQuerySection at : ElasticsearchQuerySection.values()) {
            if (at.getId().equals(id)) {
                return at;
            }
        }
        return null;
    }
}