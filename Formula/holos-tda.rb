class HolosTda < Formula
  desc "Vietoris-Rips persistent homology with an implicit ripser-class engine"
  homepage "https://github.com/t0rsion/holos"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/t0rsion/holos/releases/download/v0.6.0/holos-tda-aarch64-apple-darwin.tar.xz"
      sha256 "857c2addef793132703c251dd373d204fa84a90b40041851601b0b7c6971162a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t0rsion/holos/releases/download/v0.6.0/holos-tda-x86_64-apple-darwin.tar.xz"
      sha256 "c4200c4fdbb21b1d2e364513c30f1071213d2efcc7bb2267b451d87fb745c922"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/t0rsion/holos/releases/download/v0.6.0/holos-tda-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ebe987341c778fc36b65e7a0da560c42443bb8f2907747e47216fcc51e5f1532"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t0rsion/holos/releases/download/v0.6.0/holos-tda-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3c3d4dde868462d7ab5ba254451cec50afc8d02ed7e434be7416add275306c4a"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "holos"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "holos"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "holos"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "holos"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
