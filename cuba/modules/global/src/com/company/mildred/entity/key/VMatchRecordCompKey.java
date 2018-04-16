package com.company.mildred.entity.key;

import javax.persistence.Embeddable;
import com.haulmont.chile.core.annotations.MetaClass;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import javax.persistence.Lob;
import java.util.Objects;
import com.haulmont.cuba.core.entity.EmbeddableEntity;

@DesignSupport("{'imported':true}")
@MetaClass(name = "mildred$VMatchRecordCompKey")
@Embeddable
public class VMatchRecordCompKey extends EmbeddableEntity {
    private static final long serialVersionUID = -2298364820244174761L;

    @Lob
    @Column(name = "document_path", nullable = false)
    protected String documentPath;

    @Lob
    @Column(name = "match_path", nullable = false)
    protected String matchPath;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        VMatchRecordCompKey entity = (VMatchRecordCompKey) o;
        return Objects.equals(this.matchPath, entity.matchPath) &&
                Objects.equals(this.documentPath, entity.documentPath);
    }

    @Override
    public int hashCode() {
        return Objects.hash(matchPath, documentPath);
    }


    public void setDocumentPath(String documentPath) {
        this.documentPath = documentPath;
    }

    public String getDocumentPath() {
        return documentPath;
    }

    public void setMatchPath(String matchPath) {
        this.matchPath = matchPath;
    }

    public String getMatchPath() {
        return matchPath;
    }


}