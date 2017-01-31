package com.angrysurfer.mildred.cuba.primary.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import com.haulmont.cuba.core.entity.BaseIdentityIdEntity;

@DesignSupport("{'imported':true}")
@Table(name = "document_attribute")
@Entity(name = "primary$DocumentAttribute")
public class DocumentAttribute extends BaseIdentityIdEntity {
    private static final long serialVersionUID = -1637267946906647789L;

    @JoinTable(name = "alias_document_attribute",
        joinColumns = @JoinColumn(name = "document_attribute_id"),
        inverseJoinColumns = @JoinColumn(name = "alias_id"))
    @ManyToMany
    protected List<Alias> alias;

    @Column(name = "index_name", nullable = false, length = 128)
    protected String indexName;

    @Column(name = "document_format", nullable = false, length = 32)
    protected String documentFormat;

    @Column(name = "attribute_name", nullable = false, length = 128)
    protected String attributeName;

    @Column(name = "active_flag", nullable = false)
    protected Boolean activeFlag = false;

    public void setAlias(List<Alias> alias) {
        this.alias = alias;
    }

    public List<Alias> getAlias() {
        return alias;
    }

    public void setIndexName(String indexName) {
        this.indexName = indexName;
    }

    public String getIndexName() {
        return indexName;
    }

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