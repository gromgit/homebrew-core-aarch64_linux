class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v13.7.0",
      revision: "943fc2521df7d18aacd73ab211c35546ace47c27"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "fa7fb8c6e9aa870c6f99ea9b7c900f8e26c0959ca2dd4db272b82eb80564be9b" => :big_sur
    sha256 "66e7158a51e584ad2cc7f587b2146b5841ce1e1e30e5dc3353f6f00818ba86ac" => :arm64_big_sur
    sha256 "1b22b36fa6d32ce822eef5164e510a1580d242eb830f9e90111ecb5ad16a17b5" => :catalina
    sha256 "163e0e10323ec2e18e62b58773a5b45179db0d0f737aae7b636f2814738c4854" => :mojave
  end

  depends_on "go" => :build

  def install
    dir = buildpath/"src/gitlab.com/gitlab-org/gitlab-runner"
    dir.install buildpath.children

    cd dir do
      proj = "gitlab.com/gitlab-org/gitlab-runner"
      system "go", "build", "-ldflags", <<~EOS
        -X #{proj}/common.NAME=gitlab-runner
        -X #{proj}/common.VERSION=#{version}
        -X #{proj}/common.REVISION=#{Utils.git_short_head(length: 8)}
        -X #{proj}/common.BRANCH=#{version.major}-#{version.minor}-stable
        -X #{proj}/common.BUILT=#{Time.new.strftime("%Y-%m-%dT%H:%M:%S%:z")}
      EOS

      bin.install "gitlab-runner"
    end
  end

  plist_options manual: "gitlab-runner start"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>SessionCreate</key><false/>
          <key>KeepAlive</key><true/>
          <key>RunAtLoad</key><true/>
          <key>Disabled</key><false/>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/gitlab-runner</string>
            <string>run</string>
            <string>--working-directory</string>
            <string>#{ENV["HOME"]}</string>
            <string>--config</string>
            <string>#{ENV["HOME"]}/.gitlab-runner/config.toml</string>
            <string>--service</string>
            <string>gitlab-runner</string>
            <string>--syslog</string>
          </array>
          <key>EnvironmentVariables</key>
            <dict>
              <key>PATH</key>
              <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
          </dict>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-runner --version")
  end
end
