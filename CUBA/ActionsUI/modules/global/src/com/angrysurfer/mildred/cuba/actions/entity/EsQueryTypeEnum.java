package com.angrysurfer.mildred.cuba.actions.entity;

import com.haulmont.chile.core.datatypes.impl.EnumClass;

import javax.annotation.Nullable;


public enum EsQueryTypeEnum implements EnumClass<String> {
    Match("MATCH"),
    Match_All("MATCH_ALL");

    private String id;

    EsQueryTypeEnum(String value) {
        this.id = value;
    }

    public String getId() {
        return id;
    }

    @Nullable
    public static EsQueryTypeEnum fromId(String id) {
        for (EsQueryTypeEnum at : EsQueryTypeEnum.values()) {
            if (at.getId().equals(id)) {
                return at;
            }
        }
        return null;
    }
}