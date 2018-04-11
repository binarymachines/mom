package com.angrysurfer.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.chile.core.annotations.NamePattern;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@NamePattern("%s|name")
@Table(name = "document_category")
@Entity(name = "mildred$DocumentCategory")
public class DocumentCategory extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 2322505175879866234L;

    @Column(name = "name", nullable = false, length = 256)
    protected String name;

    @Column(name = "document_type", nullable = false, length = 128)
    protected String documentType;

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setDocumentType(String documentType) {
        this.documentType = documentType;
    }

    public String getDocumentType() {
        return documentType;
    }


}