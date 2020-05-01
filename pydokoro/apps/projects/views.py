from rest_framework import viewsets
from rest_framework import permissions
from .models import Project
from .serializers import ProjectSerializer
from rest_framework.exceptions import PermissionDenied
from rest_framework.views import APIView
# Create your views here.
class IsOwner(permissions.BasePermission):

    def has_object_permission(self, request, view, obj):
        print(obj.owner)
        print(request.user)
        return obj.owner == request.user


class ProjectViewSet(viewsets.ModelViewSet):
    serializer_class = ProjectSerializer
    permission_classes = (IsOwner,)

    def get_queryset(self):
        user = self.request.user
        if user.is_authenticated:
            return Project.objects.filter(owner=user)
        raise PermissionDenied()

    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)


class TESTView(viewsets.ModelViewSet):
    permission_classes = (permissions.AllowAny,)

    def get_queryset(self):
        user = self.request.user
        return Project.objects.filter(owner=user)
