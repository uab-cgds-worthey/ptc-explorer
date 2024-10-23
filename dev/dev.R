# Use this script to test code blocks for app dev. 
# Make sure to add this "dev" directory 
# in your gitignore after template initialization.


sample_variants

sample_variants[duplicated(sample_variants[,c("Genes","Variant","Type","DITTO")]),]

sample_var_test <- sample_variants[!duplicated(sample_variants[,c("Genes","Variant","Type", "DITTO")]),]

nrow(sample_var_test)

plot(sample_var_test$Participant_id,
     sample_var_test$DITTO)



ggplot(sample_var_test[sample_var_test$Genes == "DICER1",], aes(x=Variant, y=DITTO, fill = Type)) + 
  geom_bar(stat="identity",  width=0.2) +
  theme_minimal()+
  coord_flip()

table(sample_var_test$chrom)
ggplot(sample_var_test[sample_var_test$chrom == "chr7",], aes(x=Variant, y=DITTO, fill = Genes)) + 
  geom_bar(stat="identity",  width=0.2) +
  theme_minimal()+
  coord_flip()
  # geom_text(
  #   label=sample_variants$Variant[sample_var_test$Genes == "BRSK1"], 
  #  # nudge_x = 0.25, nudge_y = 0.25, 
  #   check_overlap = T
  # )
library(ggpattern)

ggplot(sample_var_test[sample_var_test$chrom == "chr8",], aes(x=Variant, y=DITTO, fill = Genes)) +
geom_col_pattern(
  aes(pattern=Type,
      pattern_angle=Type,
      pattern_spacing=Type
  ),
#  fill            = 'white',
  colour          = 'black', 
  pattern_density = 0.2, 
  pattern_fill    = 'black',
  pattern_colour  = 'darkgrey')
  
  


plotly(sample_variants$Participant_id,
       sample_variants$DITTO)
sample_variants$pos