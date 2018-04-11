package com.angrysurfer.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@Table(name = "document_attribute")
@Entity(name = "mildred$DocumentAttribute")
public class DocumentAttribute extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 6681116956657160427L;

    @Column(name = "document_format", nullable = false, length = 32)
    protected String documentFormat;

    @Column(name = "attribute_name", nullable = false, length = 128)
    protected String attributeName;

    @Column(name = "active_flag", nullable = false)
    protected Boolean activeFlag = false;

    public void setDocumentFormat(String documentFormat) {
        this.documentFormat = documentFormat;
    }

    public String getDocumentFormat() {
        return documentFormat;
    }

    public void setAttributeName(String attributeName) {
        this.attributeName = attributeName;
    }

    public String getAttributeName() {
        return attributeName;
    }

    public void setActiveFlag(Boolean activeFlag) {
        this.activeFlag = activeFlag;
    }

    public Boolean getActiveFlag() {
        return activeFlag;
    }


}