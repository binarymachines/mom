package com.angrysurfer.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.chile.core.annotations.NamePattern;
import com.haulmont.cuba.core.global.DesignSupport;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@NamePattern("%s|name")
@Table(name = "alias")
@Entity(name = "mildred$Alias")
public class Alias extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 2028539801476739725L;

    @Column(name = "name", nullable = false, length = 25)
    protected String name;

    @JoinTable(name = "alias_document_attribute",
        joinColumns = @JoinColumn(name = "alias_id"),
        inverseJoinColumns = @JoinColumn(name = "document_attribute_id"))
    @ManyToMany
    protected List<DocumentAttribute> documentAttribute;

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setDocumentAttribute(List<DocumentAttribute> documentAttribute) {
        this.documentAttribute = documentAttribute;
    }

    public List<DocumentAttribute> getDocumentAttribute() {
        return documentAttribute;
    }


}