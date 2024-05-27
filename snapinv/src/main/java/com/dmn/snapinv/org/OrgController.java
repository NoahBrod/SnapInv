package com.dmn.snapinv.org;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;


@Controller
public class OrgController {
    @Autowired
    private OrgService orgService;

    @GetMapping("/org/create")
    public String createOrg(@RequestParam(required = false) String error, Model model) {
        model.addAttribute("org", new Organization());
        return "create_org";
    }

    @PostMapping("/org/create")
    public String createOrg(Organization org) {
        orgService.findOrgById(org.getId());
        
        return org.toString();
    }
    
}
