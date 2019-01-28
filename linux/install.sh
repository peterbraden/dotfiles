

# 1 Password
curl https://cache.agilebits.com/dist/1P/op/pkg/v0.5.5/op_linux_amd64_v0.5.5.zip > 1p.zip
unzip 1p.zip
gpg --receive-keys 3FEF9748469ADBE15DA7CA80AC2D62742012EA22
gpg --verify op.sig op
sudo mv op /usr/local/bin
rm op.sig

