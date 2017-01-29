package com.angrysurfer.mildred.cuba.actions.entity;

import com.haulmont.chile.core.datatypes.impl.EnumClass;

import javax.annotation.Nullable;


public enum DispatchTypeEnum implements EnumClass<String> {

    Action("ACTION"),
    Condition("CONDITION");

    private String id;

    DispatchTypeEnum(String value) {
        this.id = value;
    }

    public String getId() {
        return id;
    }

    @Nullable
    public static DispatchTypeEnum fromId(String id) {
        for (DispatchTypeEnum at : DispatchTypeEnum.values()) {
            if (at.getId().equals(id)) {
                return at;
            }
        }
        return null;
    }
}