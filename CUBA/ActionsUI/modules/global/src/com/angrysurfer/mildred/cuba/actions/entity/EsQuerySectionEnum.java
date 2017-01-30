package com.angrysurfer.mildred.cuba.actions.entity;

import com.haulmont.chile.core.datatypes.impl.EnumClass;

import javax.annotation.Nullable;


public enum EsQuerySectionEnum implements EnumClass<String> {

    must("MUST"),
    must_not("MUST_NOT"),
    should("SHOULD");

    private String id;

    EsQuerySectionEnum(String value) {
        this.id = value;
    }

    public String getId() {
        return id;
    }

    @Nullable
    public static EsQuerySectionEnum fromId(String id) {
        for (EsQuerySectionEnum at : EsQuerySectionEnum.values()) {
            if (at.getId().equals(id)) {
                return at;
            }
        }
        return null;
    }
}