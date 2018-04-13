package com.company.mildred.entity.key;

import javax.persistence.Embeddable;
import com.haulmont.chile.core.annotations.MetaClass;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import java.util.Objects;
import com.haulmont.cuba.core.entity.EmbeddableEntity;

@DesignSupport("{'imported':true}")
@MetaClass(name = "mildred$VMActionMReasonsCompKey")
@Embeddable
public class VMActionMReasonsCompKey extends EmbeddableEntity {
    private static final long serialVersionUID = -7968479618453120253L;

    @Column(name = "meta_action", nullable = false)
    protected String metaAction;

    @Column(name = "reason", nullable = false)
    protected String reason;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        VMActionMReasonsCompKey entity = (VMActionMReasonsCompKey) o;
        return Objects.equals(this.reason, entity.reason) &&
                Objects.equals(this.metaAction, entity.metaAction);
    }

    @Override
    public int hashCode() {
        return Objects.hash(reason, metaAction);
    }


    public void setMetaAction(String metaAction) {
        this.metaAction = metaAction;
    }

    public String getMetaAction() {
        return metaAction;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getReason() {
        return reason;
    }


}