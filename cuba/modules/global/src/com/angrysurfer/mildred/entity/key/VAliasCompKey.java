package com.angrysurfer.mildred.entity.key;

import javax.persistence.Embeddable;
import com.haulmont.chile.core.annotations.MetaClass;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import java.util.Objects;
import com.haulmont.cuba.core.entity.EmbeddableEntity;

@DesignSupport("{'imported':true}")
@MetaClass(name = "mildred$VAliasCompKey")
@Embeddable
public class VAliasCompKey extends EmbeddableEntity {
    private static final long serialVersionUID = -4881258273253666758L;

    @Column(name = "document_format", nullable = false, length = 32)
    protected String documentFormat;

    @Column(name = "name", nullable = false, length = 25)
    protected String name;

    @Column(name = "attribute_name", nullable = false, length = 128)
    protected String attributeName;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        VAliasCompKey entity = (VAliasCompKey) o;
        return Objects.equals(this.name, entity.name) &&
                Objects.equals(this.attributeName, entity.attributeName) &&
                Objects.equals(this.documentFormat, entity.documentFormat);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, attributeName, documentFormat);
    }


    public void setDocumentFormat(String documentFormat) {
        this.documentFormat = documentFormat;
    }

    public String getDocumentFormat() {
        return documentFormat;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setAttributeName(String attributeName) {
        this.attributeName = attributeName;
    }

    public String getAttributeName() {
        return attributeName;
    }


}