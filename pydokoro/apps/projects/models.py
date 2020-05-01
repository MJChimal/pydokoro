from django.db import models
from django.contrib.auth.models import User
from typing import Final, final

_PROJECT_TITLE_MAX_LENGTH: Final = 80

# Create your models here.
@final
class Project(models.Model):
    owner = models.ForeignKey(User, on_delete=models.CASCADE)
    title = models.CharField(max_length=_PROJECT_TITLE_MAX_LENGTH)
    content = models.TextField()

    created_at = models.DateTimeField(auto_now_add=True)
    modifiet_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.title

