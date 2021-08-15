class Course < ApplicationRecord

    def checkIfBlank(attr, tba=false)
        if self[attr] == "" || self[attr] == nil
            if tba
                "TBA"
            else
                "N/A"
            end
        else
            self[attr]
        end
    end


    def cleanOneStat(attr, rank=false)
        result = self.checkIfBlank(attr)

        result == "N/A" ? result = "N/A" : result = self[attr].round(2)

        if rank 
            if result != "N/A"
                result = result.round.ordinalize 
            end
        end
        result
    end

    def classifyGut 
        if (self["gut_percentile"] == nil || self["gut_percentile_subject"] == nil) 
            return "N/A"
        
        elsif (self["gut_percentile"] >= 75 && self["gut_percentile_subject"] >= 50 && (self["workload_percentile"] != nil && self["workload_percentile"] <= 25) && (self["workload_percentile_subject"] != nil && self["workload_percentile_subject"] <= 50) && (self["professor_percentile"] != nil && self["professor_percentile"] >= 75) && (self["professor_percentile_subject"] != nil && self["professor_percentile_subject"] >= 50)) 
            return "Gut"
           
        elsif ((100 >= self["gut_percentile"] && self["gut_percentile"] >= 67) || (100 >= self["gut_percentile_subject"] && self["gut_percentile_subject"] >= 67)) 
            return "Relaxed"
        
        elsif ((67 > self["gut_percentile"] && self["gut_percentile"] > 33) || (67 > self["gut_percentile_subject"] && self["gut_percentile"] > 33)) 
            return "Average"
        
        elsif (self["gut_percentile"] <= 25 && self["gut_percentile_subject"] < 50 && (self["workload_percentile"] != nil && self["workload_percentile"] >= 75) && (self["workload_percentile_subject"] != nil && self["workload_percentile_subject"] > 50) && (self["professor_percentile"] != nil && self["professor_percentile"] <= 25) && (self["professor_percentile_subject"] != nil && self["professor_percentile_subject"] < 50)) 
            return "Grueling"
        else 
        # case when (33 >= course["gut_percentile"] >= 0) || (33 >= course["gut_percentile_subject"] >= 0)
            return "Challenging"
        end
    end
        
    def classifyProf 
        if (self["professor_percentile"] == nil || self["professor_percentile_subject"] == nil) 
            return "N/A"
        
        elsif (self["professor_percentile"] >= 75 && self["professor_percentile_subject"] >= 50 && (self["workload_percentile"] != nil && self["workload_percentile"] <= 25) && (self["workload_percentile_subject"] != nil && self["workload_percentile_subject"] <= 50) && (self["professor_percentile"] != nil && self["professor_percentile"] >= 75)) 
            return "Exceptional"
        elsif ((100 >= self["professor_percentile"] && self["professor_percentile"] >= 67) || (100 >= self["professor_percentile_subject"] && self["professor_percentile_subject"] >= 67)) 
            return "Good"
        
        elsif ((67 > self["professor_percentile"] && self["professor_percentile"] > 33) || (67 > self["professor_percentile_subject"] && self["professor_percentile"] > 33)) 
            return "Average"
        
        elsif (self["professor_percentile"] <= 25 && self["professor_percentile_subject"] < 50 && (self["workload_percentile"] != nil && self["workload_percentile"] >= 75) && (self["workload_percentile_subject"] != nil && self["workload_percentile_subject"] > 50) && (self["professor_percentile"] != nil && self["professor_percentile"] <= 25)) 
            return "Harsh"
        else 
        # // case when (33 >= self["gut_percentile"] >= 0) || (33 >= self["gut_percentile_subject"] >= 0)
            return "Tough"
        end
    end
        
    

    def classifyWork 
        if (self["workload_percentile"] == nil || self["workload_percentile_subject"] == nil) 
            return "N/A"
        
        elsif (self["workload_percentile"] >= 67 && self["workload_percentile_subject"] >= 67) 
            return "Heavy"
           
        elsif ((67 > self["workload_percentile"] && self["workload_percentile"] >= 33) && (67 > self["workload_percentile_subject"] && self["workload_percentile_subject"] >= 33)) 
            return "Average"
        
        elsif ((self["workload_percentile"] < 33) && (self["workload_percentile_subject"] < 33)) 
            return "Light"
        
        elsif (self["workload_percentile"] > 50 && self["workload_percentile_subject"] >= 67)
            return "Relatively Harsh"
        
        elsif (self["workload_percentile"] < 50 && self["workload_percentile_subject"] <= 33)
            return "Relatively Light"
        
        else 
        # // case when (33 >= course["gut_percentile"] >= 0) || (33 >= course["gut_percentile_subject"] >= 0)
            return "Relatively Average"
        end
    end

    def combineSkillsAndAreas
        # // combine skills and areas
        if (self.areas == "" && self.skills == "" ) 
            skills_and_areas = "N/A"
        elsif ( self.skills == "") 
            skills_and_areas = self.areas.gsub(',','')
        elsif ( self.areas == "") 
            skills_and_areas = self.skills.gsub(',','')
        
        else 
            skills_and_areas = self.areas.gsub(',','') + " " + self.skills.gsub(',','')
        end
    end
        
    def season_to_str(season) 
        season_str = String(season)
    
        year = season_str[0...4]
    
        season_code = season_str[4...6]
   
    
        if (season_code == "01") 
            semester = "Spring"
        
        elsif (season_code == "02") 
            semester = "Summer"
         
        else 
            semester = "Fall"
        
        end
        return semester + " " + year
    end
    
    
    

end
