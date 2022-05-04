class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/v4.45.0.tar.gz"
  sha256 "fb8731295d8bbad9ef9157dbd3bc62655752d36544e0cc4077d4fa8a8a4ea295"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1d4a5a52eb68fc2a71253e73580f817c6cd93f9abeb99ba0118d3195ef5947f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dabb385bea5d1f9e48338bb8ced9e3fd5b3bdc887efe1cd07735f2d0b5cf66b2"
    sha256 cellar: :any_skip_relocation, monterey:       "b5dc47fb201f8866ad923a604f6a496e7166b77e72920917ed680a58e3359cd7"
    sha256 cellar: :any_skip_relocation, big_sur:        "fec542c76f363926f202e4ac51d7655b5e29918aaf23b300792367364a9a19a4"
    sha256 cellar: :any_skip_relocation, catalina:       "17bd04b4c99a8e230b255bbc3e3a464e8282b8abfc0ac860e20503479fcb5179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c2677f269cdec295906a6823002b6e456655227e210d55d10208f4a535593b3"
  end

  # Bump to Go 1.18 with when v5 releases.
  depends_on "go@1.17" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202204280105/geoip.dat"
    sha256 "38fe72a33f23920cf14e804bf14c26ea0210db3ea2108a2d51fa32c48ac53170"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202204280105/geoip-only-cn-private.dat"
    sha256 "e8d0d7469b90e718f3b5cba033fec902dd05fab44c28c779a443e4c1f8aa0bf2"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20220501162639/dlc.dat"
    sha256 "dff924231ec74dd51d28177e57bc4fd918f212d993a6c1264f335e966ceb5aa9"
  end

  def install
    ldflags = "-s -w -buildid="
    execpath = libexec/name
    system "go", "build", *std_go_args, "-o", execpath,
                 "-ldflags", ldflags,
                 "./main"
    system "go", "build", *std_go_args,
                 "-ldflags", ldflags,
                 "-tags", "confonly",
                 "-o", bin/"v2ctl",
                 "./infra/control/main"
    (bin/"v2ray").write_env_script execpath,
      V2RAY_LOCATION_ASSET: "${V2RAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgetc.install "release/config/config.json"

    resource("geoip").stage do
      pkgshare.install "geoip.dat"
    end

    resource("geoip-only-cn-private").stage do
      pkgshare.install "geoip-only-cn-private.dat"
    end

    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
  end

  service do
    run [bin/"v2ray", "-config", etc/"v2ray/config.json"]
    keep_alive true
  end

  test do
    (testpath/"config.json").write <<~EOS
      {
        "log": {
          "access": "#{testpath}/log"
        },
        "outbounds": [
          {
            "protocol": "freedom",
            "tag": "direct"
          }
        ],
        "routing": {
          "rules": [
            {
              "ip": [
                "geoip:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            },
            {
              "domains": [
                "geosite:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            }
          ]
        }
      }
    EOS
    output = shell_output "#{bin}/v2ray -c #{testpath}/config.json -test"

    assert_match "Configuration OK", output
    assert_predicate testpath/"log", :exist?
  end
end
