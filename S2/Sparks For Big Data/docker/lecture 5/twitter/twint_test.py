import twint

# Configure
c = twint.Config()
c.Search = "spark"

# Run
twint.run.Search(c)
