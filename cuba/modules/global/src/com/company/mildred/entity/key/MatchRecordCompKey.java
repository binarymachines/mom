package com.company.mildred.entity.key;

import javax.persistence.Embeddable;
import com.haulmont.chile.core.annotations.MetaClass;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import java.util.Objects;
import com.haulmont.cuba.core.entity.EmbeddableEntity;

@DesignSupport("{'imported':true}")
@MetaClass(name = "mildred$MatchRecordCompKey")
@Embeddable
public class MatchRecordCompKey extends EmbeddableEntity {
    private static final long serialVersionUID = -1219185614949297136L;

    @Column(name = "doc_id", nullable = false, length = 128)
    protected String doc;

    @Column(name = "match_doc_id", nullable = false, length = 128)
    protected String matchDoc;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        MatchRecordCompKey entity = (MatchRecordCompKey) o;
        return Objects.equals(this.matchDoc, entity.matchDoc) &&
                Objects.equals(this.doc, entity.doc);
    }

    @Override
    public int hashCode() {
        return Objects.hash(matchDoc, doc);
    }


    public void setDoc(String doc) {
        this.doc = doc;
    }

    public String getDoc() {
        return doc;
    }

    public void setMatchDoc(String matchDoc) {
        this.matchDoc = matchDoc;
    }

    public String getMatchDoc() {
        return matchDoc;
    }


}