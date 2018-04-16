package com.company.mildred.entity.key;

import javax.persistence.Embeddable;
import com.haulmont.chile.core.annotations.MetaClass;
import com.haulmont.cuba.core.global.DesignSupport;
import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import java.util.Objects;
import com.haulmont.cuba.core.entity.EmbeddableEntity;

@DesignSupport("{'imported':true}")
@MetaClass(name = "mildred$VModeStateCompKey")
@Embeddable
public class VModeStateCompKey extends EmbeddableEntity {
    private static final long serialVersionUID = -1615929225752283982L;

    @Column(name = "mode_name", nullable = false, length = 128)
    protected String modeName;

    @Column(name = "state_name", nullable = false, length = 128)
    protected String stateName;

    @Column(name = "pid", nullable = false, length = 32)
    protected String pid;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "effective_dt")
    protected Date effectiveDt;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        VModeStateCompKey entity = (VModeStateCompKey) o;
        return Objects.equals(this.modeName, entity.modeName) &&
                Objects.equals(this.stateName, entity.stateName) &&
                Objects.equals(this.effectiveDt, entity.effectiveDt) &&
                Objects.equals(this.pid, entity.pid);
    }

    @Override
    public int hashCode() {
        return Objects.hash(modeName, stateName, effectiveDt, pid);
    }


    public void setModeName(String modeName) {
        this.modeName = modeName;
    }

    public String getModeName() {
        return modeName;
    }

    public void setStateName(String stateName) {
        this.stateName = stateName;
    }

    public String getStateName() {
        return stateName;
    }

    public void setPid(String pid) {
        this.pid = pid;
    }

    public String getPid() {
        return pid;
    }

    public void setEffectiveDt(Date effectiveDt) {
        this.effectiveDt = effectiveDt;
    }

    public Date getEffectiveDt() {
        return effectiveDt;
    }


}