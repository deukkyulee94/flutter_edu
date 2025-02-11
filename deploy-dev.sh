
flutter build web --web-renderer html &&
aws s3 sync ./build/web s3://evan-front && 
aws cloudfront create-invalidation --distribution-id EPTBBATJHTN32 --paths '/*'\
