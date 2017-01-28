package com.angrysurfer.mildred.cuba.actions.entity;

import com.haulmont.chile.core.datatypes.impl.EnumClass;

import javax.annotation.Nullable;


public enum DocumentTypeEnum implements EnumClass<String> {

    Directory("DIRECTORY"),
    File("FILE");

    private String id;

    DocumentTypeEnum(String value) {
        this.id = value;
    }

    public String getId() {
        return id;
    }

    @Nullable
    public static DocumentTypeEnum fromId(String id) {
        for (DocumentTypeEnum at : DocumentTypeEnum.values()) {
            if (at.getId().equals(id)) {
                return at;
            }
        }
        return null;
    }
}