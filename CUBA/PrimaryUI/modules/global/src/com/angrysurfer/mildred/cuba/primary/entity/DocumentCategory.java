package com.angrysurfer.mildred.cuba.primary.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.chile.core.annotations.NamePattern;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import com.haulmont.cuba.core.entity.BaseIdentityIdEntity;

@DesignSupport("{'imported':true,'unmappedColumns':['effective_dt','expiration_dt']}")
@NamePattern("%s|name")
@Table(name = "document_category")
@Entity(name = "primary$DocumentCategory")
public class DocumentCategory extends BaseIdentityIdEntity {
    private static final long serialVersionUID = 7065105880624143766L;

    @Column(name = "index_name", nullable = false, length = 128)
    protected String indexName;

    @Column(name = "name", nullable = false, length = 256)
    protected String name;

    @Column(name = "document_type", nullable = false, length = 128)
    protected String documentType;

    public void setIndexName(String indexName) {
        this.indexName = indexName;
    }

    public String getIndexName() {
        return indexName;
    }

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