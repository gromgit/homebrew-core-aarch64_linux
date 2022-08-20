class Stubby < Formula
  desc "DNS privacy enabled stub resolver service based on getdns"
  homepage "https://dnsprivacy.org/wiki/display/DP/DNS+Privacy+Daemon+-+Stubby"
  license "BSD-3-Clause"
  head "https://github.com/getdnsapi/stubby.git", branch: "develop"

  stable do
    url "https://github.com/getdnsapi/stubby/archive/v0.4.1.tar.gz"
    sha256 "e195f278d16c861a2fb998f075f48b4b5b905b17fc0f33859da03f884b4a4cad"

    # Fix test yml reference issue, remove in next version
    patch do
      url "https://github.com/getdnsapi/stubby/commit/cf9e0f5d97e518f2edb1c21801f2ccf133467f2b.patch?full_index=1"
      sha256 "9d888aab5448b47e844731e640ef9fa9ec6085128247824b3bb2c949d92a1a8d"
    end
  end

  bottle do
    sha256 arm64_monterey: "b4ea31171be5dba8e1bc76c7dc2afadabff6ed7a5f2daed0b999c351b3dd54d1"
    sha256 arm64_big_sur:  "da69e1f67fdacfa3157b7ce65d54a882bafea078034675a740b5ce84a73474b8"
    sha256 monterey:       "01fdc08df8fd30578f6dbf3548c1e41db0f3e7ac23043df4f993b68f129058dd"
    sha256 big_sur:        "30321706c1c048e6b5b37f5c478539e5cda15f1b406a33cb851d51a2d52d0cd0"
    sha256 catalina:       "76fcc1a8bf4fd749cdcdfdd3a21a548f0d085f574f8bc170e6cb8a7ec6840a60"
    sha256 x86_64_linux:   "7366b9c82ea0f57196ef84e98d8715caf2a795a06bcc9f55d50f0078b854f763"
  end

  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "getdns"
  depends_on "libyaml"

  on_linux do
    depends_on "bind" => :test
  end

  def install
    system "cmake", "-DCMAKE_INSTALL_RUNSTATEDIR=#{HOMEBREW_PREFIX}/var/run/", \
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{HOMEBREW_PREFIX}/etc", ".", *std_cmake_args
    system "make", "install"
  end

  service do
    run [opt_bin/"stubby", "-C", etc/"stubby/stubby.yml"]
    keep_alive true
    run_type :immediate
  end

  test do
    assert_predicate etc/"stubby/stubby.yml", :exist?
    (testpath/"stubby_test.yml").write <<~EOS
      resolution_type: GETDNS_RESOLUTION_STUB
      dns_transport_list:
        - GETDNS_TRANSPORT_TLS
        - GETDNS_TRANSPORT_UDP
        - GETDNS_TRANSPORT_TCP
      listen_addresses:
        - 127.0.0.1@5553
      idle_timeout: 0
      upstream_recursive_servers:
        - address_data: 145.100.185.15
        - address_data: 145.100.185.16
        - address_data: 185.49.141.37
    EOS
    output = shell_output("#{bin}/stubby -i -C stubby_test.yml")
    assert_match "bindata for 145.100.185.15", output

    fork do
      exec "#{bin}/stubby", "-C", testpath/"stubby_test.yml"
    end
    sleep 2

    assert_match "status: NOERROR", shell_output("dig @127.0.0.1 -p 5553 getdnsapi.net")
  end
end
