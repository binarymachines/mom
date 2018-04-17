package com.angrysurfer.mildred.entity.service.key;

import javax.persistence.Embeddable;
import com.haulmont.chile.core.annotations.MetaClass;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import java.util.Objects;
import com.haulmont.cuba.core.entity.EmbeddableEntity;

@DesignSupport("{'imported':true}")
@MetaClass(name = "mildred$VServiceSwitchRuleCompKey")
@Embeddable
public class VServiceSwitchRuleCompKey extends EmbeddableEntity {
    private static final long serialVersionUID = 3543261842879071615L;

    @Column(name = "pk_sp_id", nullable = false)
    protected Integer pkSp;

    @Column(name = "pk_sd_id", nullable = false)
    protected Integer pkSd;

    @Column(name = "pk_mode_id", nullable = false)
    protected Integer pkMode;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        VServiceSwitchRuleCompKey entity = (VServiceSwitchRuleCompKey) o;
        return Objects.equals(this.pkSd, entity.pkSd) &&
                Objects.equals(this.pkMode, entity.pkMode) &&
                Objects.equals(this.pkSp, entity.pkSp);
    }

    @Override
    public int hashCode() {
        return Objects.hash(pkSd, pkMode, pkSp);
    }


    public void setPkSp(Integer pkSp) {
        this.pkSp = pkSp;
    }

    public Integer getPkSp() {
        return pkSp;
    }

    public void setPkSd(Integer pkSd) {
        this.pkSd = pkSd;
    }

    public Integer getPkSd() {
        return pkSd;
    }

    public void setPkMode(Integer pkMode) {
        this.pkMode = pkMode;
    }

    public Integer getPkMode() {
        return pkMode;
    }


}