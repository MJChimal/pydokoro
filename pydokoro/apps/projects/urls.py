from django.urls import path
from rest_framework.routers import SimpleRouter
from .views import ProjectViewSet, TESTView

router = SimpleRouter()
router.register('projects', ProjectViewSet, basename='projects')
router.register('test', TESTView, basename='test')
urlpatterns = router.urls
